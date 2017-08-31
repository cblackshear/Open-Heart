 
********************************************************************;
******************** Section 2: Demographics ***********************;
********************************************************************;

title1 "Section 2: Demographics";

*Produce basic statistics*******************************************;

*Variable List;

  *Continuous;                    
   %let contvar = age brthyr;

   *Categorical;                   
   %let catvar  = brthmo sex male menopause;

*Simple Data Listing & Summary Stats;
%simple;

*Cross-tabs and other validations***********************************;
title "summary of age by sex";
proc means data = validation;
class sex;
var age;
run;

proc sgplot data = validation;
title1;
title2 'Age vs. Year of Birth';
xaxis label='Year of Birth';
yaxis label='Age';
  scatter y=age x=brthyr / markerattrs=(symbol=circlefilled size=3);
  run; quit;
 
title1 "Section 2: Demographics";

title2 "Sex Classification vs. Male Indicator";
proc freq data = validation;
  tables sex*male;
  format male;
  run;

title2 "Sex Classification vs Menopause Indicator";
proc freq data = validation;
  tables sex*menopause / missing;
  run;

%put Section 02 Complete;
