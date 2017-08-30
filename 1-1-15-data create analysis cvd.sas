********************************************************************;
***************** Section 15: Non-Adjudicated CVD ******************;
********************************************************************;

title "Section 15: Non-Adjudicated CVD";

*PFHA;
data include1; *PFHA;
  set jhsV1.pfha(keep = subjid pfha4a);
  by subjid;

  *Create renamed duplicates for formulas;
  MIdoc = pfha4a;
  run;

*MHXA;
data include2; *MHXA;
  set jhsV1.mhxa(keep = subjid  mhxa17   mhxa31  mhxa32  mhxa52a
                           mhxa52c mhxa52e1 mhxa54a mhxa54b mhxa55a);
  by subjid;

  *Drop all formats to make definitions easier;
  format _all_;

  *Create renamed duplicates for formulas;
  docChestPain       = mhxa17;
  docChestPain30     = mhxa31;
  MIhosp             = mhxa32;
  coronaryByp        = mhxa52a;
  carotidEnd         = mhxa52c;
  arterialRevasc     = mhxa52e1;
  coronaryAngio      = mhxa54a;
  angioplastarteryV1 = mhxa54b;
  heartCath          = mhxa55a;
  run;

*analysis;
data include3; *analysis;
  set analysis(keep = subjid MIecg strokeHX);
  by subjid;
  run;

*Combine datasets sequentially;
*Combine 1 & 2;
data include; *Combine 1 & 2;
  merge include1(in = in1) 
        include2(in = in2);
  by subjid;
    inc1 = in1; 
    inc2 = in2; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include; 
    drop inc1 inc2 chkobs; 
    run;

*Combine 1-2 & 3; 
data include; *Combine 1-2 & 3;
  merge include(in = in1) 
        include3(in = in2);
  by subjid;
    inc1 = in1; 
    inc2 = in2; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include; 
    drop inc1 inc2 chkobs; 
    run;

*Create variables;
data include; 
  set include; *Create variables;
  by subjid;

  *Variable: MIHx;
  MIHx = 0;
  if (MIdoc = "Y" OR docChestPain = "H" OR docChestPain30 = "H" OR MIhosp = "Y")        then MIHx = 1;
  if missing(MIdoc) & missing(docChestPain) & missing(docChestPain30) & missing(MIhosp) then MIHx = .;
  label MIHx = "Self-Reported History of MI";
  format MIHx ynfmt.;
  
  *Variable: CardiacProcHx;
  CardiacProcHx = 0;
  if (coronaryByp = "Y" OR carotidEnd = "Y" OR arterialRevasc = "Y" OR coronaryAngio = "Y" OR heartCath = "Y")          then CardiacProcHx = 1;
  if coronaryByp = "" & carotidEnd = "" & arterialRevasc = "" & coronaryAngio = "" & heartCath = "" then CardiacProcHx = .;
  label CardiacProcHx = "Self-Reported history of Cardiac Procedures";
  format CardiacProcHx ynfmt.;

  *Variable: CHDHx;
  CHDHx = 0;
  if MIecg = 1 | MIHx = 1           then CHDHx = 1; 
  if missing(MIecg) & missing(MIHx) then CHDHx = .;
  label CHDHx = "Coronary Heart Disease Status/History";
  format CHDHx ynfmt.;

  *Variable: CarotidAngioHx;
  angioplastarteryV2 = "N";
  angioplastarteryV3 = "N";

  angioplastartery = "N";
  if (angioplastarteryV1 = "Y"    | angioplastarteryV2 = "Y"    | angioplastarteryV3 = "Y")   then angioplastartery = "Y";
  if  missing(angioplastarteryV1) & missing(angioplastarteryV2) & missing(angioplastarteryV3) then angioplastartery = .;

  if angioplastartery = "Y" then CarotidAngioHx = 1; else 
  if angioplastartery = "N" then CarotidAngioHx = 0; else 
  CarotidAngioHx =.;
  label CarotidAngioHx = "Self-Reported history of Carotid Angioplasty";
  format CarotidAngioHx ynfmt.;
    
  *Variable: CVDHx;
  CVDHx = 0;
  if (CHDHx = 1 | CarotidAngioHx = 1 | strokeHx = 1)              then CVDHx = 1;
  if missing(CHDHx) & missing(CarotidAngioHx) & missing(strokeHx) then CVDHx = .;
  label CVDHx = "Cardiovascular Disease History" ;
  format CVDHx ynfmt.;
  run;

*Add to Analysis Dataset;
data analysis; *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
    if in1 = 1; *Only keep clean ptcpts;
  run;
  /*Checks;
  proc contents data = analysis; run;
  proc print data = analysis(obs = 5); run;
  */

*Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep15cvd = MIHx CardiacProcHx CHDHx CarotidAngioHx CVDHx;

%put Section 15 Complete;
