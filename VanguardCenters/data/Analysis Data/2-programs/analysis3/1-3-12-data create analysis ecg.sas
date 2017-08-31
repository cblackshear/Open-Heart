********************************************************************;
****************** Section 12: Electrocardiogram *******************;
********************************************************************;

title "Section 12: Electrocardiogram";

*ECGB;
data include1; *ECGB;
  set jhsv3.ecgb(keep = subjid ecgb14 ecgb21-ecgb31 ecgb42 ecgb46 ecgb48 ecgb65 ecgb81);
  by subjid;

  *Create renamed duplicates for formulas;
  ecgHR = ecgb48;
  AR83X = ecgb14; 
  QRS   = ecgb42; 
  QT    = ecgb46; 

  atrioVentr = ecgb22;
  intraVentr = ecgb21;
  
  QnQsA      = ecgb25;
  stjDeprA   = ecgb30;
  twveA      = ecgb31;

  QnQsP      = ecgb24;
  stjDeprP   = ecgb28;
  twveP      = ecgb29;

  QnQsAL     = ecgb23; 
  stjDeprAL  = ecgb26;
  twveAL     = ecgb27;

  RampAVL    = ecgb65;
  SampV3     = ecgb81;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid male);
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

  *Variable: ConductionDefect;
  ConductionDefect = 0;
  if atrioVentr in (6 8)  then ConductionDefect = 1;
  if intraVentr in (4 11) then ConductionDefect = 1;
  label ConductionDefect = "Conduction Defect";
  format ConductionDefect ynfmt.;

  *Variable: MIant;

    *Subvariable: MajorScarAnt;
    MajorScarAnt = 0;
    if QnQsA in (11 12 16 17 21 22 27) then MajorScarAnt = 1;
    label MajorScarAnt = "ECG determined Anterior Major Scar";

    *Subvariable: MinorScarAnt;
    MinorScarAnt = 0;
    if QnQsA in (31 32 38) then MinorScarAnt = 1;
    label MinorScarAnt = "ECG determined Anterior Minor Scar";
 
    *Subvariable: RepolarAnt;
    RepolarAnt = 0;
    if twveA in (1 2) | stjDeprA in (2 11 12) then RepolarAnt = 1;
    label RepolarScarAnt = "ECG determined Anterior Repolarization";

  MIant = 0;
  if MajorScarAnt = 1 | (MinorScarAnt = 1 & RepolarAnt = 1) then MIant = 1;
  if ConductionDefect = 1                                   then MIant = 0;

  label MIant = "ECG determined Anterior MI";
  format MIant ynfmt.;

  *Variable: MIpost;

    *Subvariable: MajorScarPost;
    MajorScarPost = 0;
    if QnQsP in (11 12 14 15 21 22 23 24 25) then MajorScarPost = 1;
    label MajorScarPost = "ECG determined Posterior Major Scar";

    *Subvariable: MinorScarPost;
    MinorScarPost = 0;
    if QnQsP in (31 34 35 36) then MinorScarPost = 1;
    label MinorScarPost = "ECG determined Posterior Minor Scar";

    *Subvariable: RepolarPost;
    RepolarPost = 0;
    if twveP in (1 2) | stjDeprP in (2 11 12) then RepolarPost = 1;
    label RepolarPost = "ECG determined Posterior Repolarization";

  MIpost = 0;
  if MajorScarPost = 1 | (MinorScarPost = 1 & RepolarPost = 1) then MIpost = 1;
  if ConductionDefect = 1                                      then MIpost = 0;

  label MIpost = "ECG determined Posterior MI";  
  format MIpost ynfmt.;

  *Variable: MIantlat;

    *Subvariable: MajorScarAntLat;
    MajorScarAntLat = 0;
    if QnQsAL in (11 12 13 21 22 23) then MajorScarAntLat = 1;
    label MajorScarAntLat = "ECG determined Anterolateral Major Scar";
    
    *Subvariable: RepolarAnt;
    RepolarAntLat = 0;
    if twveAL in (1 2) | stjDeprAL in (2 11 12) then RepolarAntLat = 1;
    label MinorScarAntLat = "ECG determined Anterolateral Minor Scar";

    *Subvariable: MinorScarAntLat;
    MinorScarAntLat = 0;
    if QnQsAL in (31 33 38) then MinorScarAntLat = 1;
    label RepolarAntLat = "ECG determined Anterolateral Repolarization";

  MIantlat = 0;
  if MajorScarAntLat = 1 | (RepolarAntLat & MinorScarAntLat = 1) then MIantlat = 1;
  if ConductionDefect = 1                                        then MIantlat = 0;

  label MIantlat = "ECG determined Anterolateral MI";
  format MIantlat ynfmt.;

  *Variable: MIecg;

  MIecg = 0;
    if  (MajorScarAnt = 1 | MajorScarPost = 1 | MajorScarAntLat = 1) |
       ((MinorScarAnt = 1 | MinorScarPost = 1 | MinorScarAntLat = 1) & (RepolarAnt = 1 | RepolarPost = 1 | RepolarAntLat = 1))
    then MIecg = 1;

  if (ConductionDefect = 1 & MIecg = 1) then MIecg = 0;

  label MIecg = "ECG determined MI";
  format MIecg ynfmt.;

  *Variable: ecgHR;
  label  ecgHR = "Heart Rate (bpm)";
  format ecgHR 8.2;

  *Variable: Afib;
  if (missing(AR83X) and NOT missing(ecgHR)) or AR83X = 2 then Afib = 0; else
  if AR83X = 1                                            then Afib = 1; else
  Afib = .;
  label  Afib = "Atrial Fibrillation";
  format Afib ynfmt.;

  *Variable: Aflutter;
  if (missing(AR83X) and NOT missing(ecgHR)) or AR83X = 1 then Aflutter = 0; else
  if AR83X = 2                                            then Aflutter = 1; else
  Aflutter = .;
  label  Aflutter = "Atrial Flutter ";
  format Aflutter ynfmt.;

  *Variable: QRS;
  label  QRS = "QRS Interval (msec)";
  format QRS 8.2;

  *Variable: QT;
  label  QT = "QT Interval (msec)";
  format QT 8.2;

  *Variable: QTcFram;
  QTcFram = QT + 154 * (1 - (60/ecgHR));
  label QTcFram = "Framingham Corrected QT Interval (msec)";
  format QTcFram 8.0;

  *Variable: QTcBaz;
  QTcBaz = QT * ((ecgHR / 60)**(1/2));
  label  QTcBaz = "Bazett Corrected QT Interval (msec)";
  format QTcBaz 8.0;

  *Variable: QTcHod;
  QTcHod = QT + 1.75*(ecgHR - 60);
  label QTcHod = "Hodge Corrected QT Interval (msec)";
  format QTcHod 8.0;

  *Variable: QTcFrid;
  QTcFrid = QT * ((ecgHR / 60)**(1/3));
  label QTcFrid = "Fridericia Corrected QT Interval (msec)";
  format QTcFrid 8.0;

  *Variable: CV;
  CV = RampAVL + ABS(SampV3);
  label  CV = "Cornell Voltage (microvolts)";
  format CV 8.0;

  *Variable: LVHcv;
  LVHcv = .;
    if male = 1 & ^missing(CV) then do;
      if CV <= 2800 then LVHcv = 0;
      if CV >  2800 then LVHcv = 1;
      end;
    if male = 0 & ^missing(CV) then do;
      if CV <= 2000 then LVHcv = 0;
      if CV >  2000 then LVHcv = 1;
      end;

  label  LVHcv = "Cornell Voltage Criteria";
  format LVHcv pafmt.;
  run;

*Add to Analysis Dataset;
data analysis; *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
    if in1 = 1; *Only keep clean ptcpts;
  run;
  /*Checks;
  proc contents data = analysis; run;
  proc print data = analysis(obs = 500); run;
  */

%put Section 12 Complete;
