********************************************************************;
********************* Section 13: CT Imaging ***********************;
********************************************************************;

title "Section 13: CT Imaging";

*CSTA;
data include1; *CSTA;
  set jhsV2.csta(keep = subjid csta24 csta69 csta101-csta103 );
  by subjid;

  *Create renamed duplicates for formulas;
  CAC     = csta24;
  AAC     = csta69;
  TotalAbdFat = csta101;
  VATandIntra = csta102;
  VAT50mm     = csta103;
  run;

*Combine datasets and merge checking variables;
data include; *Combine datasets and merge checking variables;
  merge include1(in = in1);
  by subjid; 
    inc1 = in1; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1*inc2 /missing; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 chkobs;
    run;

*Create variables; 
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: VAT50mm;
  label VAT50mm = "Visceral Adipose Tissue (cm^3)";
  format VAT50mm 8.2;

  *Variable: SAT50mm;
  SAT50mm = TotalAbdFat - VATandIntra;
  label SAT50mm = "Subcutaneous Adipose Tissue (cm^3)";
  format SAT50mm 8.2;

  *Variable: CAC;
  label CAC = "Coronary Artery Calcium Score";
  format CAC 8.2;

  *Variable: AAC;
  label AAC = "Abdominal Aorto-iliac Calcium Score";
  format AAC 8.2;

  *Variable: anyCAC;
  anyCAC = 0;
  if CAC > 0      then anyCAC = 1;
  if missing(CAC) then anyCAC = .;
  label anyCAC = "Presence of Coronary Artery Calcification";
  format anyCAC ynfmt.;

  *Variable: anyAAC;
  anyAAC = 0;
  if AAC > 0      then anyAAC = 1;
  if missing(AAC) then anyAAC = .;
  label anyAAC = "Presence of Aortic Artery Calcification";
  format anyAAC ynfmt.;
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
%let keep13ct = VAT50mm SAT50mm CAC AAC anyCAC anyAAC;

%put Section 13 Complete;
