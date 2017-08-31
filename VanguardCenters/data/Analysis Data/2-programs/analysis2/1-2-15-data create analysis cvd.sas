********************************************************************;
***************** Section 15: Non-Adjudicated CVD ******************;
********************************************************************;

title "Section 15: Non-Adjudicated CVD";

*MHXA;
data include1; *MHXA;
  set jhsV1.mhxa(keep = subjid mhxa54b);
  by subjid;

  *Create renamed duplicates for formulas;
  angioplastarteryV1 = mhxa54b;
  run;

*MHXB;
data include2; *MHXB;
  set jhsV2.mhxb(keep = subjid  mhxb17 mhxb31 mhxb32 mhxb52a mhxb52c mhxb52e1 mhxb54a mhxb54b mhxb55a);
  by subjid;

  *Create renamed duplicates for formulas;
  docChestPain       = mhxb17;
  docChestPain30     = mhxb31;
  MIhosp             = mhxb32;
  coronaryByp        = mhxb52a;
  carotidEnd         = mhxb52c;
  arterialRevasc     = mhxb52e1;
  coronaryAngio      = mhxb54a;
  angioplastarteryV2 = mhxb54b;
  heartCath          = mhxb55a;  
  run;

*analysis;
data include3; *analysis;
  set analysis(keep = subjid strokeHX);
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
  MIdoc = .; *Not collected in Visit 2;

  MIHx = 0;
  if (MIdoc = 1 OR docChestPain = 2 OR docChestPain30 = 1 OR MIhosp = 1)                then MIHx = 1;
  if missing(MIdoc) & missing(docChestPain) & missing(docChestPain30) & missing(MIhosp) then MIHx = .;
  label MIHx = "Self-Reported History of MI";
  format MIHx ynfmt.;

  *Variable: CardiacProcHx;
  CardiacProcHx = 0;
  if (coronaryByp = 1 OR carotidEnd = 1 OR arterialRevasc = 1 OR coronaryAngio = 1 OR heartCath = 1) then CardiacProcHx = 1;
  if coronaryByp = "" & carotidEnd = "" & arterialRevasc = "" & coronaryAngio = "" & heartCath = ""  then CardiacProcHx = .;
  label CardiacProcHx = "Self-Reported history of Cardiac Procedures";
  format CardiacProcHx ynfmt.;

  *Variable: CHDHx;
  CHDHx = .; *Not Collected in Visit 2;
  label CHDHx = "Coronary Heart Disease Status/History";
  format CHDHx ynfmt.;

  *Variable: CarotidAngioHx;
  angioplastarteryV3 = "";

  angioplastartery = "N";
  if (angioplastarteryV1 = "Y"    | angioplastarteryV2 = 1      | angioplastarteryV3 = 1)     then angioplastartery = "Y";
  if  missing(angioplastarteryV1) & missing(angioplastarteryV2) & missing(angioplastarteryV3) then angioplastartery = .;

  if angioplastartery = "N" then CarotidAngioHx = 0; else 
  if angioplastartery = "Y" then CarotidAngioHx = 1; else 
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

%put Section 15 Complete;
