********************************************************************;
*********************** Section 9: Renal ***************************;
********************************************************************;

title "Section 9: Renal";

*LOCA;
data include1; *LOCA;
  set jhsV1.loca(keep = subjid creatinine);
  by subjid;

  *Create renamed duplicates for formulas;
  SCr = creatinine;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid age male);
  by subjid;
  run;

*LOCAU24H;
data include3; *LOCAU24H;
  set jhsV1.locau24h(keep = subjid ur_creatinine ur_albumin_24hr);
  by subjid;

  *Create renamed duplicates for formulas;
  CreatinineU24hr = ur_creatinine;  
  AlbuminU24hr = ur_albumin_24hr; 
  run;

*LOCASPOT;
data include4; *LOCASPOT;
  set jhsV1.locaspot(keep = subjid rs_creat urine_albumin);
  by subjid;

  *Create renamed duplicates for formulas;
  CreatinineUSpot = rs_creat;  
  AlbuminUSpot = urine_albumin; 
  run;

*MHXA;
data include5; *MHXA;
  set jhsV1.mhxa(keep = subjid mhxa57 mhxa58a mhxa58b);
  by subjid;

  *Create renamed duplicates for formulas;
  dialysisYNV1 = mhxa57;
  monthsDialysis = mhxa58a;
  yearsDialysis = mhxa58b;
  run;

*PFHA;
data include6; *PFHA;
  set jhsv1.pfha(keep = subjid pfha7a);
  by subjid;

  *Create renamed duplicates for formulas;
  CKDYN = pfha7a;
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
data include; *Combine 1-2 & 3;
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
data include; *Combine 1-2 & 3;
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
  SCrCC = 1.0025253 - (0.89677 / sqrt(0.9214)) * 0.9626263 + (0.89677 / sqrt(0.9214)) * SCr;
  label  SCrCC = "CC Calibrated Serum Creatinine (mg/dL)";
  format SCrCC 8.2;

  *Variable: SCrIDMS;
  SCrIDMS = SCr * 0.968113 - 0.024778;
  label  SCrIDMS = "IDMS Traceable Serum Creatinine (mg/dL)";
  format SCrIDMS 8.2;

  *Variable: eGFRmdrd;
  eGFRmdrd = 186.3 * ((SCrCC)**-1.154) * ((age)**-0.203) * (0.742**(1 - male)) * 1.212;
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
  label  CreatinineU24hr = "24-hour urine creatinine (g/24hr)";
  format CreatinineU24hr 8.2;

  *Variable: CreatinineUSpot;
  label  CreatinineUSpot = "Random spot urine creatinine (mg/dL)";
  format CreatinineUSpot 8.2;

  *Variable: AlbuminUSpot;
  label  AlbuminUSpot = "Random spot urine albumin (mg/dL)";
  format AlbuminUSpot 8.2;

  *Variable: AlbuminU24hr;
  label  AlbuminU24hr = "24-hour urine albumin (mg/24hr)";
  format AlbuminU24hr 8.2;

  *Variable: DialysisEver;
  dialysisYNV2 = ' ';
  dialysisYNV3 = ' ';

  dialysisYN = 'N';
  if (dialysisYNV1 = 'Y' | dialysisYNV2 = 1 | dialysisYNV3 = 1) then dialysisYN = 'Y';
  if missing(dialysisYNV1)                                      then dialysisYN = .;
 
  if dialysisYN = 'N' then DialysisEver = 0; else
  if dialysisYN = 'Y' then DialysisEver = 1; else
  DialysisEver = .;
  label DialysisEver = "Self-reported dialysis";
  format DialysisEver ynfmt.;

  *Variable: DialysisDuration;

    *Subvariable: yearsDialysisV1;
    if missing(yearsDialysis) and NOT missing(monthsDialysis) then yearsDialysis = 0;
    if missing(monthsDialysis) and NOT missing(yearsDialysis) then monthsDialysis = 0;
    yearsDialysisV1 = round((yearsDialysis * 12 + monthsDialysis) / 12);

    *Subvariable: yearsDialysisV2;
    yearsDialysisV2 = .;

    *Subvariable: yearsDialysisV3;
    yearsDialysisV3 = .;

  DialysisDuration = max(yearsDialysisV1, yearsDialysisV2, yearsDialysisV3);
  if missing(yearsDialysisV1) & missing(yearsDialysisV2) & missing(yearsDialysisV3) then DialysisDuration = .;                
  label  DialysisDuration = "Duration on dialysis (years)";
  format DialysisDuration 3.0;

  *Variable: CKDHx;
  if ckdyn = "Y" then CKDHx = 1;
  if ckdyn = "N" then CKDHx = 0;
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

*Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep09renal = SCrCC            SCrIDMS       eGFRmdrd      eGFRckdepi    CreatinineU24hr  
                   CreatinineUSpot  AlbuminUSpot  AlbuminU24hr  DialysisEver  DialysisDuration  CKDHx;

%put Section 09 Complete;
