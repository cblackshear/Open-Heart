********************************************************************;
******************** Section 10: Respiratory ***********************;
********************************************************************;

title "Section 10: Respiratory";

*RPAA;
data include1; *RPAA;
  set jhsV1.rpaa(keep = subjid rpaa13 rpaa14 rpaa16);
  by subjid;

  *Create renamed duplicates for formulas;
  everHadAsthma   = rpaa13;
  confirmedAsthma = rpaa14;
  stillHaveAsthma = rpaa16;
  run;

*PULA;
data include2; *PULA;
  set jhsV1.pula(keep = subjid pula16 pula17 pula27 pula37 pula18 
                           pula28 pula38 pula24 pula34 pula44);
  by subjid;

  *Create renamed duplicates for formulas;
  FVC1      = pula17; 
  FVC2      = pula27;   
  FVC3      = pula37; 
  FEV11     = pula18; 
  FEV12     = pula28; 
  FEV13     = pula38; 
  FEV61     = pula24; 
  FEV62     = pula34; 
  FEV63     = pula44;
  maneuvers = pula16;
  run;

*analysis;
data include3; *analysis;
  set analysis(keep = subjid age sex height);
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
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: asthma;
  if everHadAsthma = 'N' | (everHadAsthma   = 'Y' & confirmedAsthma = 'N') then asthma = 0; else
  if everHadAsthma = 'Y' &  confirmedAsthma = 'Y' & stillHaveAsthma = 'N'  then asthma = 1; else
  if everHadAsthma = 'Y' &  confirmedAsthma = 'Y' & stillHaveAsthma = 'Y'  then asthma = 2; else
  asthma = .; 
  label  asthma = "Physician-Diagnosed Asthma";
  format asthma asthma.;

  *Variable: maneuvers; 
  label  maneuvers = "Successful Spirometry Maneuvers";
  format maneuvers 3.0;

  *Variable: FVC;
  array FVCarray{3} FVC1 - FVC3;
  if maneuvers >= 3 then FVC = max(of FVCarray{*});
  else FVC = .;
  label  FVC = "Forced Vital Capacity (L)";
  format FVC 8.2;

  *Variable: FEV1;
  array FEV1array{3} FEV11 - FEV13;
  if maneuvers >= 3 then FEV1 = max(of FEV1array{*});
  else FEV1 = .;
  label  FEV1 = "Forced Expiratory Volume in 1 Second (L)";
  format FEV1 8.2;

  *Variable: FEV6;
  array FEV6array{3} FEV61 - FEV63;
  if maneuvers >= 3 then FEV6 = max(of FEV6array{*});
  else FEV6 = .;
  label  FEV6 = "Forced Expiratory Volume in 6 Seconds (L)";
  format FEV6 8.2; 

  *Variable: FEV1PP;           ****************Something is off here. Verify with ADDVT;
  if      sex = 'Male'   then FEV1_Pred = 0.3411 - 0.02309*age + 0.00013194*height**2;
  else if sex = 'Female' then FEV1_Pred = 0.3433 - 0.01283*age + 0.00010846*height**2 - 0.000097*age**2; 
  FEV1PP = (FEV1/FEV1_Pred)*100;
  label  FEV1PP = "FEV1 % Predicted";
  format FEV1PP 8.2;

  *Variable: FVCPP;            ****************Something is off here. Verify with ADDVT;
  if      sex = 'Male'   then  FVC_Pred = -0.1517 - 0.01821*age + 0.00016643*height**2;
  else if sex = 'Female' then  FVC_Pred = -0.3039 + 0.00536*age + 0.00013606*height**2 - 0.000265*age**2;
  else FVC_Pred = .;
  FVCPP = (FVC/FVC_Pred)*100;
  label  FVCPP = "FVC % Predicted";
  format FVCPP 8.2;
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
%let keep10resp = asthma  maneuvers  FVC  FEV1  FEV6  
                  FEV1PP  FVCPP;

%put Section 10 Complete;
