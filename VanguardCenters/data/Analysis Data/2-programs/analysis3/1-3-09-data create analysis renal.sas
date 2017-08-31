********************************************************************;
*********************** Section 9: Renal ***************************;
********************************************************************;

title "Section 9: Renal";

*analysis;
data include1; *analysis;
  set analysis(keep = subjid age male);
  by subjid;
  run;

*CENC;
data include2; *CENC;
  set jhsV3.cenc(keep = subjid creatr crdur umali);
  by subjid;

  *Create renamed duplicates for formulas;
  SCr = creatr;
  CreatinineUSpot = crdur;  
  AlbuminUSpot = umali / 10; 
  run;

*MHXA;
data include3; *MHXA;
  set jhsV1.mhxa(keep = subjid mhxa57 mhxa58a mhxa58b);
  by subjid;

  *Create renamed duplicates for formulas;
  monthsDialysis = mhxa58a;
  yearsDialysis = mhxa58b;
  dialysisV1 = mhxa57;
  run;

*RDFA;
data include4; *RDFA;
  set jhsV2.rdfa(keep = subjid rdfa3 rdfa4a);
  by subjid;

  *Create renamed duplicates for formulas;
  dialysisV2      = rdfa3;
  yearsDialysisV2 = rdfa4a;
  run;

*RDFB;
data include5; *RDFB;
  set jhsV3.rdfb(keep = subjid rdfb3 rdfb4a);
  by subjid;

  *Create renamed duplicates for formulas;
  dialysisV3 = rdfb3;
  yearsDialysisV3 = rdfb4a;
  run;

*PFHB;
data include6; *PFHB;
  set jhsv3.pfhb(keep = subjid pfhb7a);
  by subjid;

  *Create renamed duplicates for formulas;
  CKDYN = pfhb7a;
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

*Combine 1-3 & 4; 
data include; *Combine 1-3 & 4;
  merge include(in = in1) 
        include4(in = in2);
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

*Combine 1-4 & 5; 
data include; *Combine 1-4 & 5;
  merge include(in = in1) 
        include5(in = in2);
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

*Combine 1-5 & 6; 
data include; *Combine 1-5 & 6;
  merge include(in = in1) 
        include6(in = in2);
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
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: SCrCC;
  SCrCC = .; *Not available in Visit 3;
  label  SCrCC = "CC Calibrated Serum Creatinine (mg/dL)";
  format SCrCC 8.2;

  *Variable: SCrIDMS;
  SCrIDMS = SCr;
  label  SCrIDMS = "IDMS Traceable Serum Creatinine (mg/dL)";
  format SCrIDMS 8.2;

  *Variable: eGFRmdrd;
  eGFRmdrd = 175 * ((SCrIDMS)**-1.154) * ((age)**-0.203) * (0.742**(1 - male)) * 1.212;
  label  eGFRmdrd = "eGFR MDRD";
  format eGFRmdrd 8.2;

  *Variable: eGFRckdepi;
  eGFRckdepi = .;
    if ^missing(SCrIDMS) then do;
      if male = 1 then eGFRckdepi = 141 * (min((SCrIDMS/0.9), 1)**(-0.411)) * (max((SCrIDMS/0.9), 1)**(-1.209)) * 0.993**age         * 1.159;
      if male = 0 then eGFRckdepi = 141 * (min((SCrIDMS/0.7), 1)**(-0.329)) * (max((SCrIDMS/0.7), 1)**(-1.209)) * 0.993**age * 1.018 * 1.159;
      end;
  label  eGFRckdepi = "eGFR CKD-Epi";
  format eGFRckdepi 8.2;

  *Variable: CreatinineU24hr;
  CreatinineU24hr = .; *Not collected in Visit 3;
  label  CreatinineU24hr = "24-hour urine creatinine (g/24hr)";
  format CreatinineU24hr 8.2;

  *Variable: CreatinineUSpot;
  label  CreatinineUSpot = "Random spot urine creatinine (mg/dL)";
  format CreatinineUSpot 8.2;

  *Variable: AlbuminUSpot;
  label  AlbuminUSpot = "Random spot urine albumin (mg/dL)";
  format AlbuminUSpot 8.2;

  *Variable: AlbuminU24hr; 
  AlbuminU24hr = .; *Not collected in Visit 3;
  label  AlbuminU24hr = "24-hour urine albumin (mg/ 24hr)";
  format AlbuminU24hr 8.2;

  *Variable:  DialysisEver;   
  DialysisEver = 0;
  if dialysisV1 = 'Y' or dialysisV2 = 1 or dialysisV3 = 1                then DialysisEver = 1;
  if missing(dialysisV1) and missing(dialysisV2) and missing(dialysisV3) then DialysisEver = .;
  label Dialysis = "Self-reported dialysis";
  format Dialysis ynfmt.;

  *Variable: DialysisDuration;

    *Subvariable: yearsDialysisV1;
    if missing(yearsDialysis) and NOT missing(monthsDialysis) then yearsDialysis = 0;
    if missing(monthsDialysis) and NOT missing(yearsDialysis) then monthsDialysis = 0;
    yearsDialysisV1 = round((yearsDialysis * 12 + monthsDialysis) / 12);

  if yearsDialysisV2 in (77,88,99) then yearsDialysisV2=.;
  if yearsDialysisV3 in (77,88,99) then yearsDialysisV3=.;
  DialysisDuration = max(yearsDialysisV1, yearsDialysisV2, yearsDialysisV3);
  if missing(yearsDialysisV1) and missing(yearsDialysisV2) and missing(yearsDialysisV3) then DialysisDuration = .;                
  label  DialysisDuration = "Duration on dialysis (years)";
  format DialysisDuration 6.2;

  *Variable: CKDHx;
  if ckdyn = 1 then CKDHx = 1;
  if ckdyn = 2 then CKDHx = 0;
  label  CKDHx = "Chronic Kidney Disease History";
  format CKDHx ynfmt.;
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

%put Section 09 Complete;
