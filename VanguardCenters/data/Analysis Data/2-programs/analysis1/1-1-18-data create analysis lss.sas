********************************************************************;
******************* Section 18: Life's Simple 7 ********************;
********************************************************************;

title "Section 18: Life's Simple 7";

*TOBA;
data include1; *TOBA;
  set jhsV1.toba(keep = subjid toba4a toba4b);
  by subjid;

  *Create renamed duplicates for formulas;
  yearsQuit = toba4b + (toba4a/12);
    *Address potential missingness issue that would prevent correct calculation of number of years quit;
    if missing(toba4a) then yearsQuit = toba4b;    
    if missing(toba4b) then yearsQuit = toba4a/12;
  run;

*ANALYSIS;
data include2; *ANALYSIS;
	set analysis(keep = subjid currentSmoker everSmoker BMI totChol statinMeds sbp dbp HbA1c3cat FPG3cat BPmeds DMmeds);
	by subjid;
	run;

*Simple7V1;
data include3; *Simple7V1;
	set lss.Simple7V1(keep = subjid PA3cat nutrition3cat);
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

  *Variable: SMK3cat;
       if currentSmoker = 1                                        then SMK3cat = 0; *Poor Health         (Current smoker);
  else if                     yearsQuit <  1 & ^missing(yearsQuit) then SMK3cat = 1; *Intermediate Health (Quit < 12 months ago);
  else if                     yearsQuit >= 1 & ^missing(yearsQuit) then SMK3cat = 2; *Ideal Health        (Quit >= 12 months ago);
  else if everSmoker    = 0                                        then SMK3cat = 2; *Ideal Health        (Never smoked);    
  else    SMK3cat = .;

  label  SMK3cat = "AHA Smoking Categorization";
  format SMK3cat LSS3cat.;

  *Variable idealHealthSMK;
  idealHealthSMK = .;
    if SMK3cat in (0 1) then idealHealthSMK = 0;
    if SMK3cat in (2)   then idealHealthSMK = 1;
  
  format idealHealthSMK YNfmt.;
  label  idealHealthSMK = "Indicator for Ideal Health via Smoking Status";

  *Variable: BMI3cat;
  BMI3cat = .;
  if 30 <= round(BMI, 0.1)                        & ^missing(BMI) then BMI3cat = 0; *Poor Health         (Obese: >= 30);
  if 25 <= round(BMI, 0.1) & round(BMI, 0.1) < 30 & ^missing(BMI) then BMI3cat = 1; *Intermediate Health (Overweight: 25-29.9);
  if                         round(BMI, 0.1) < 25 & ^missing(BMI) then BMI3cat = 2; *Ideal Health        (Ideal: < 25);

  label  BMI3cat = "AHA BMI Categorization";
  format BMI3cat LSS3cat.;

  *Variable idealHealthBMI;
  idealHealthBMI = .;
    if BMI3cat in (0 1) then idealHealthBMI = 0;
    if BMI3cat in (2)   then idealHealthBMI = 1;
  
  format idealHealthBMI YNfmt.;
  label  idealHealthBMI = "Indicator for Ideal Health via BMI Status";

  *Variable: PA3cat;
  label  PA3cat = "AHA Physical Activity Categorization";
  format PA3cat LSS3cat.;
  
  *Variable idealHealthPA;
  idealHealthPA = .;
    if PA3cat in (0 1) then idealHealthPA = 0;
    if PA3cat in (2)   then idealHealthPA = 1;
  
  format idealHealthPA YNfmt.;
  label  idealHealthPA = "Indicator for Ideal Health via Physical Activity Status";

  *Variable: nutrition3cat;
  label  nutrition3cat = "AHA Nutrition Categorization";
  format nutrition3cat LSS3cat.;

  *Variable idealHealthNutrition;
  idealHealthNutrition = .;
    if nutrition3cat in (0 1) then idealHealthNutrition = 0;
    if nutrition3cat in (2)   then idealHealthNutrition = 1;
  
  format idealHealthNutrition YNfmt.;
  label  idealHealthNutrition = "Indicator for Ideal Health via Nutrition Status";

  *Variable: totChol3cat;
  totChol3cat = .;
  if 240 <= totChol                        & ^missing(totChol)                        then totChol3cat = 0; *Poor Health         (>= 240);
  if 200 <= totChol < 240                  & ^missing(totChol)                        then totChol3cat = 1; *Intermediate Health (200-239, if untreated);
  if        totChol < 200 & statinMeds = 1 & ^missing(totChol) & ^missing(statinMeds) then totChol3cat = 1; *Intermediate Health (200, if treated);
  if        totChol < 200 & statinMeds = 0 & ^missing(totChol) & ^missing(statinMeds) then totChol3cat = 2; *Ideal Health        (< 200, if untreated);

  label  totChol3cat = "AHA Total Cholesterol Categorization";
  format totChol3cat LSS3cat.;

  *Variable idealHealthChol;
  idealHealthChol = .;
    if totChol3cat in (0 1) then idealHealthChol = 0;
    if totChol3cat in (2)   then idealHealthChol = 1;
  
  format idealHealthChol YNfmt.;
  label  idealHealthChol = "Indicator for Ideal Health via Cholesterol Status";

  *Variable: BP3cat;
  BP3cat = .;
  if (               sbp < 120  &              dbp < 80  ) & BPmeds = 0 & ^missing(sbp) & ^missing(dbp) & ^missing(BPmeds) then BP3cat = 2; *Ideal Health        (SBP < 120 AND DBP < 80, if untreated);
  if ( (120 <= sbp & sbp < 140) | (80 <= dbp & dbp < 90) )              & ^missing(sbp) & ^missing(dbp)                    then BP3cat = 1; *Intermediate Health (SBP 120-139 OR DBP 80-89);
  if (               sbp < 120  &              dbp < 80  ) & BPmeds = 1 & ^missing(sbp) & ^missing(dbp) & ^missing(BPmeds) then BP3cat = 1; *Intermediate Health (SBP < 120 AND DBP < 80, if treated);
  if (  140 <= sbp              |  90 <= dbp             )              & ^missing(sbp) & ^missing(dbp)                    then BP3cat = 0; *Poor Health         (SBP >= 140 OR DBP >= 90);

  label  BP3cat = "AHA BP Categorization";
  format BP3cat LSS3cat.;

  *Variable idealHealthBP;
  idealHealthBP = .;
    if BP3cat in (0 1) then idealHealthBP = 0;
    if BP3cat in (2)   then idealHealthBP = 1;
  
  format idealHealthBP YNfmt.;
  label  idealHealthBP = "Indicator for Ideal Health via BP Status";

  *Variable: glucose3cat;
  glucose3cat = .;
  if  HbA1c3cat = 0 & FPG3cat = 0 & DMmeds = 0 then glucose3cat = 2; *Ideal Health        FPG < 100 mg/dL AND HbA1c < 6.5% AND untreated;
  if  HbA1c3cat = 1 | FPG3cat = 1 then glucose3cat = 1;              *Intermediate Health FPG 100-125 mg/dL OR HbA1c 5.7-6.5%;
  if (HbA1c3cat = 0 & DMmeds = 1) then glucose3cat = 1;              *Intermediate Health FPG < 100 mg/dL AND treated;
  if (FPG3cat   = 0 & DMmeds = 1) then glucose3cat = 1;              *Intermediate Health HbA1c < 6.5% AND treated;
  if  HbA1c3cat = 2 | FPG3cat = 2 then glucose3cat = 0;              *Poor Health         FPG = 126 mg/dL OR HbA1c = 6.5%;

  label  glucose3cat = "AHA Glucose Categorization";
  format glucose3cat LSS3cat.;

  *Variable idealHealthDM;
  idealHealthDM = .;
    if glucose3cat in (0 1) then idealHealthDM = 0;
    if glucose3cat in (2)   then idealHealthDM = 1;
  
  format idealHealthDM YNfmt.;
  label  idealHealthDM = "Indicator for Ideal Health via Glucose Status";
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
%let keep18lss = SMK3cat         BMI3cat         PA3cat         nutrition3cat         totChol3cat      BP3cat         glucose3cat
                 idealHealthSMK  idealHealthBMI  idealHealthPA  idealHealthNutrition  idealHealthChol  idealHealthBP  idealHealthDM; 

%put Section 18 Complete;
