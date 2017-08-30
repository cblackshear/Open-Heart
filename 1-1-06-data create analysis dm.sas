*********************************************************************;
********************** Section 6: Diabetes **************************;
*********************************************************************;

title "Section 6: Diabetes";

*LOCA;
 data include1; *LOCA;
    set jhsV1.loca(keep = subjid glucose);
    by subjid;
    run;

*CENA;
data include2; *CENA;
  set jhsV1.cena(keep = subjid insulin glyhb);
  by subjid;

  *Create renamed duplicates;
  HbA1c = glyhb;
  run;

*analysis;
data include3; *analysis;
  set analysis(keep = subjid FastHours DMmeds);
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
data include; *Create Variables;
  set include; 

  *Variable: FPG;
  if      FastHours <  8 then FPG = .; else 
	if 			FastHours >= 8 then FPG = glucose;
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
  label  HbA1c3cat = "NGSP Hemoglobin A1c (%) Categorization";
  format HbA1c3cat HbA1c3cat.;

  *Variable: HbA1cIFCC;
  HbA1cIFCC 		  = 10.93*HbA1c - 23.5;
  label HbA1cIFCC = "IFCC Hemoglobin A1c (mmol/mol)";
  format HbA1cIFCC 8.2;

  *Variable: HbA1cIFCC3cat;
  if           HbA1cIFCC <  38.801 then HbA1cIFCC3cat = 0; 
  if 38.801 <= HbA1cIFCC <  47.545 then HbA1cIFCC3cat = 1; 
  if           HbA1cIFCC >= 47.545 then HbA1cIFCC3cat = 2; 
  if missing(HbA1cIFCC)            then HbA1cIFCC3cat = .;
  label  HbA1cIFCC3cat = "IFCC Hemoglobin A1c (mmol/mol) Categorization";
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
  format diab3cat diab3cat.;  

  *Variable: HOMA_B;
  HOMA_B 			 = 20 * insulin / ((FPG / 18.1) - 3.5);
  if FastHours < 8 | Diabetes = 1 then HOMA_B = .;
  label HOMA_B = "HOMA-B";
  format HOMA_B 8.3;

  *Variable: HOMA_IR;
  HOMA_IR 		  = (FPG / 18.1) * insulin / 22.5;
  if FastHours  < 8 | Diabetes = 1 then HOMA_IR = .;
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

*Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep06dm = FPG            FPG3cat         HbA1c   HbA1c3cat  HbA1cIFCC 
                HbA1cIFCC3cat  fastingInsulin  HOMA_B  HOMA_IR    Diabetes  
                diab3cat; 

%put Section 06 Complete;
