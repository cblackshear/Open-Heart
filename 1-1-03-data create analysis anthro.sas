********************************************************************;
****************** Section 3: Anthropometrics **********************;
********************************************************************;

title "Section 3: Anthropometrics";

*ANTV;
data include1; *ANTV;
  set jhsV1.antv(keep = subjid antv3a antv2 antv1 antv3b);
  by subjid;

  *Create renamed duplicates for formulas;
  weight = antv2;
  height = antv1;
  waist  = antv3a;
  neck   = antv3b;
  run;

*Create variables; 
data include; *Create variables; 
  set include1; 
  by subjid;

  *Variable: weight;
  label  weight = "Weight (kg)";
  format weight 8.1;

  *Variable: height;
  label  height = "Height (cm)";
  format height 8.1;

  *Variable: BMI;
  BMI = weight / ((height / 100) ** 2); *in kg/m^2;
  label  BMI = "Body Mass Index (kg/m^2)";
  format BMI 8.2;

  *Variable: waist;
  label  waist = "Waist Circumference (cm)";
  format waist 8.2;

  *Variable: hip;
  hip = .; *Not collected in Visit 1;
  label  hip = "Hip Circumference (cm)";
  format hip 8.2;

  *Variable: neck;
  label  neck = "Neck Circumference (cm)";
  format neck 8.2;

  *Variable: bsa;
  bsa = 0.007184*(height**0.725)*(weight**0.425);
  label	 bsa = "Calculated Body Surface Area (m^2)";
  format bsa 8.2;

 *Variable: Obesity3cat;
  OBESITY3cat = . ;

  *NOTE: used the round function to take care of rounding issue;
  if 30 <= round(BMI, 0.1)                        & ^missing(BMI) then OBESITY3cat = 2; *Poor Health         (Obese: >= 30);
  if 25 <= round(BMI, 0.1) & round(BMI, 0.1) < 30 & ^missing(BMI) then OBESITY3cat = 1; *Intermediate Health (Overweight: 25-29.9);
  if                         round(BMI, 0.1) < 25 & ^missing(BMI) then OBESITY3cat = 0; *Ideal Health        (Ideal: < 25);

  label  OBESITY3cat = "AHA BMI Categorization";
  format OBESITY3cat obesity3cat.;

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
%let keep03anthro = weight height BMI waist hip neck bsa OBESITY3cat; 

%put Section 03 Complete;
