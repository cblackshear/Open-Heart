********************************************************************;
******************* Section 18: Life's Simple 7 ********************;
********************************************************************;

title "Section 18: Life's Simple 7";

*Variable List;
  *Continuous;                    
  %let contvar = ;

  *No categorical;                   
  %let catvar  = SMK3cat         BMI3cat         PA3cat         nutrition3cat         totChol3cat      BP3cat         glucose3cat
                 idealHealthSMK  idealHealthBMI  idealHealthPA  idealHealthNutrition  idealHealthChol  idealHealthBP  idealHealthDM; 

*Simple Data Listing & Summary Stats;
%simple;


*Cross-tabs and other validations***********************************;
data check;
  set analysis.validation1;

  if ^missing(yearsQuit) & yearsQuit < 1  then yearsQuitInd = "Quit <  12 months ago";
  if ^missing(yearsQuit) & yearsQuit >= 1 then yearsQuitInd = "Quit >= 12 months ago";
  run;

  proc freq data = check; table everSmoker*currentSmoker*yearsQuitInd*SMK3cat /list missing; run;
  proc freq data = check; table SMK3cat /missing; run;


%put Section 18 Complete;
