********************************************************************;
************************ Section 7: Lipids *************************;
********************************************************************;

title "Section 7: Lipids";

*CENB;
data include1; *CENB;
  set jhsV2.cenb(keep = subjid ldlc hdlc trr chr);
  by subjid;

  *Create renamed duplicates for formulas;
  ldl     = ldlc;
  hdl     = hdlc;
  trigs   = trr;
  totchol = chr;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid FastHours gender);
  by subjid;
  run;

*Combine datasets and merge checking variables;
data include; *Combine datasets and merge checking variables;
  merge include1(in = in1)
        include2(in = in2);
  by subjid; 
    inc1 = in1;
    inc2 = in2; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data=include; tables inc1*inc2; run;
  proc print data=include(where=(chkobs>1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: ldl;
  if (FastHours < 8 | trigs > 400) then ldl = .;
  label ldl = "Fasting LDL Cholesterol Level (mg/dL)";
  format ldl 6.2;

  *Variable: ldl5cat;
  if        ldl <  100 then ldl5cat = 0; 
  if 100 <= ldl <  130 then ldl5cat = 1;  
  if 130 <= ldl <  160 then ldl5cat = 2;  
  if 160 <= ldl <  190 then ldl5cat = 3;  
  if        ldl >= 190 then ldl5cat = 4; 
  if missing(ldl)      then ldl5cat = .;  
  label ldl5cat = "Fasting LDL Categorization";
  format ldl5cat ldl5cat.;

  *Variable: hdl;
  if FastHours < 8 then hdl = .;
  label hdl = "Fasting HDL Cholesterol Level (mg/dL)";
  format hdl 6.2;

  *Variable: hdl3cat;
  if gender = 'M' &       hdl <  40 then hdl3cat = 0; 
  if gender = 'F' &       hdl <  50 then hdl3cat = 0; 
  if gender = 'M' & 40 <= hdl <  60 then hdl3cat = 1; 
  if gender = 'F' & 50 <= hdl <  60 then hdl3cat = 1; 
  if                      hdl >= 60 then hdl3cat = 2; 
  if missing(hdl)                   then hdl3cat = .;
  label hdl3cat = "Fasting HDL Categorization";
  format hdl3cat hdl3cat.;

  *Variable: trigs;
  if FastHours < 8 then trigs = .;
  label trigs = "Fasting Triglyceride Level (mg/dL)";
  format trigs 7.2;

  *Variable: trigs4cat;
  if        trigs <  150 then trigs4cat = 0; 
  if 150 <= trigs <  200 then trigs4cat = 1; 
  if 200 <= trigs <  500 then trigs4cat = 2; 
  if        trigs >= 500 then trigs4cat = 3; 
  if missing(trigs)      then trigs4cat = .;
  label trigs4cat = "Fasting Triglyceride Categorization";
  format trigs4cat trigs4cat.;

  *Variable: totchol;
  if FastHours < 8 then totchol = .;
  label totchol = "Fasting Total Cholesterol (mg/dL)";
  format totchol 6.2;
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

%put Section 07 Complete;
