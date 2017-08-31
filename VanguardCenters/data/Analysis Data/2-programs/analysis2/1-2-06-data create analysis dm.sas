*********************************************************************;
********************** Section 6: Diabetes **************************;
*********************************************************************;

title "Section 6: Diabetes";

*CENB;
data include1; *CENB;
  set jhsV2.cenb(keep = subjid glyhb glur);
  by subjid;

  *Create renamed duplicates;
  insulin = .; *Not collected in Visit 2;
  HbA1c	  = glyhb;
  glucose = glur;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid FastHours DMmeds);
  by subjid;

  diabeticMeds = DMmeds;
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

*Create variables;
data include; *Create Variables;
  set include; 

  *Variable: FPG;
  if      FastHours <  8 then FPG = . ; 
  else if FastHours >= 8 then FPG = glucose;
  label FPG = "Fasting Plasma Glucose Level (mg/dL)";
  format FPG 8.2;

  *Variable: FPG3cat;
  if        FPG <  100 then FPG3cat = 0;
  if 100 <= FPG <  126 then FPG3cat = 1;
  if        FPG >= 126 then FPG3cat = 2;
  if missing(FPG)      then FPG3cat = .;
  label FPG3cat = "Fasting Plasma Glucose Categorization";
  format FPG3cat fpg3cat.;

  *Variable: HbA1c;
  label HbA1c = "NGSP Hemoglobin A1c (%)";
  format HbA1c 8.2;

  *Variable: HbA1c3cat;
  if        HbA1c <  5.7 then HbA1c3cat = 0; 
  if 5.7 <= HbA1c <  6.5 then HbA1c3cat = 1; 
  if        HbA1c >= 6.5 then HbA1c3cat = 2; 
  if missing(HbA1c)      then HbA1c3cat = .;
  label HbA1c3cat = "NGSP Hemoglobin A1c (%) Categorization";
  format HbA1c3cat HbA1c3cat.;

  *Variable: HbA1cIFCC;
  HbA1cIFCC = 10.93*HbA1c - 23.5;
  label HbA1cIFCC = "IFCC Hemoglobin A1c (mmol/mol)";
  format HbA1cIFCC 8.2;

  *Variable: HbA1cIFCC3cat;
  if           HbA1cIFCC <  38.801 then HbA1cIFCC3cat = 0; 
  if 38.801 <= HbA1cIFCC <  47.545 then HbA1cIFCC3cat = 1; 
  if           HbA1cIFCC >= 47.545 then HbA1cIFCC3cat = 2; 
  if missing(HbA1cIFCC)            then HbA1cIFCC3cat = .;
  label HbA1cIFCC3cat = "IFCC Hemoglobin A1c (mmol/mol) Categorization";
  format HbA1cIFCC3cat HbA1c3cat.;

  *Variable: fastingInsulin;
  if FastHours <  8 then fastingInsulin = .;
  if FastHours >= 8 then fastingInsulin = insulin;
  label fastingInsulin = "Fasting Insulin (Plasma IU/mL)";
  format fastingInsulin 8.2;

  *Variable: Diabetes;
  if HbA1c3cat in (0 1) | FPG3cat in (0 1)    then Diabetes = 0;  
  if HbA1c3cat = 2 | FPG3cat = 2 | DMmeds = 1 then Diabetes = 1;
  label Diabetes = "Diabetes Status (ADA 2010)";
  format Diabetes ynfmt.;

  *Variable: diab3cat;
  if HbA1c3cat = 0 | FPG3cat = 0              then diab3cat = 0; 
  if HbA1c3cat = 1 | FPG3cat = 1              then diab3cat = 1; 
  if HbA1c3cat = 2 | FPG3cat = 2 | DMmeds = 1 then diab3cat = 2;
  label diab3cat = "Diabetes Categorization";

  *Variable: HOMA_B;
  HOMA_B = .; *Not Available in Visit 2;
  label HOMA_B = "HOMA-B";
  format HOMA_B 8.3;

  *Variable: HOMA_IR;
  HOMA_IR = .; *Not Available in Visit 2;
  label HOMA_IR = "HOMA-IR";
  format HOMA_IR 8.3;
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

%put Section 06 Complete;
