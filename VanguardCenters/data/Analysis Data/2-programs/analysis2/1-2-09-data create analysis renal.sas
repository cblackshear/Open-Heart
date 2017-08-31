********************************************************************;
*********************** Section 9: Renal ***************************;
********************************************************************;

title "Section 9: Renal";

*analysis;
data include1; *analysis;
  set analysis(keep = subjid age male);
  by subjid;
  run;

*CENB;
data include2; *CENB;
  set jhsV2.cenb(keep = subjid crdur umali);
  by subjid;

  *Create renamed duplicates for formulas;
  CreatinineUSpot = crdur;  
  AlbuminUSpot = umali / 10 ; 
  run;

*MHXA;
data include3; *MHXA;
  set jhsV1.mhxa(keep = subjid mhxa57 mhxa58a mhxa58b);
  by subjid;

  *Create renamed duplicates for formulas;
  dialysisYNV1 = mhxa57;
  monthsDialysis = mhxa58a;
  yearsDialysis = mhxa58b;
  run;

*RDFA;
data include4; *RDFA;
  set jhsV2.rdfa(keep = subjid rdfa3 rdfa4a);
  by subjid;

  *Create renamed duplicates for formulas;
  dialysisYNV2 = rdfa3;
  yearsDialysisV2 = rdfa4a; 
  run;

*HHXA;
data include5; *HHXA;
  set jhsv2.hhxa(keep = subjid hhxa13a);
  by subjid;

  *Create renamed duplicates for formulas;
  CKDYN = hhxa13a;
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

*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: SCrCC;
  SCrCC = .; *Not available in Visit 2;
  label  SCrCC = "CC Calibrated Serum Creatinine (mg/dL)";
  format SCrCC 8.2;

  *Variable: SCrIDMS;
  SCrIDMS = .; *Not available in Visit 2;
  label  SCrIDMS = "IDMS Traceable Serum Creatinine (mg/dL)";
  format SCrIDMS 8.2;

  *Variable: eGFRmdrd;
  eGFRmdrd = .; *Not available in Visit 2;
  label  eGFRmdrd = "eGFR MDRD";
  format eGFRmdrd 8.2;

  *Variable: eGFRckdepi;
  eGFRckdepi = .; *Not available in Visit 2;
  label  eGFRckdepi = "eGFR CKD-Epi";
  format eGFRckdepi 8.2;

  *Variable: CreatinineU24hr;
  CreatinineU24hr = .; *Not collected in Visit 2;
  label  CreatinineU24hr = "24-hour urine creatinine (g/24hr)";
  format CreatinineU24hr 8.2;

  *Variable: CreatinineUSpot;
  label  CreatinineUSpot = "Random spot urine creatinine (mg/dL)";
  format CreatinineUSpot 8.2;

  *Variable: AlbuminUSpot;
  label  AlbuminUSpot = "Random spot urine albumin (mg/dL)";
  format AlbuminUSpot 8.2;

  *Variable: AlbuminU24hr; 
  AlbuminU24hr = .; *Not collected in Visit 2;
  label  AlbuminU24hr = "24-hour urine albumin (mg/24hr)";
  format AlbuminU24hr 8.2;

  *Variable: DialysisEver;
  dialysisYNV3 = ' ';

  dialysisYN = 'N';
  if (dialysisYNV1 = 'Y' | dialysisYNV2 = 1 | dialysisYNV3 = 1) then dialysisYN = 'Y';
  if missing(dialysisYNV1) & missing(dialysisYNV2)              then dialysisYN = .;
 
  if dialysisYN = 'N' then dialysisEver = 0; else
  if dialysisYN = 'Y' then dialysisEver = 1; else
  dialysisEver = .;
  label DialysisEver = "Self-reported dialysis";
  format DialysisEver ynfmt.;

  *Variable: DialysisDuration;

    *Subvariable: yearsDialysisV1;
    if missing(yearsDialysis) and NOT missing(monthsDialysis) then yearsDialysis = 0;
    if missing(monthsDialysis) and NOT missing(yearsDialysis) then monthsDialysis = 0;
    yearsDialysisV1 = round((yearsDialysis * 12 + monthsDialysis) / 12);

    *Subvariable: yearsDialysisV2;
    if yearsDialysisV2 = 99 then yearsDialysisV2 = .;

    *Subvariable: yearsDialysisV3;
    yearsDialysisV3 = .;

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
