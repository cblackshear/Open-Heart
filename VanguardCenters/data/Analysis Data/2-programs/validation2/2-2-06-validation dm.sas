********************************************************************;
****************** Section 6: Diabetes **********************;
********************************************************************;

title1 "Section 06: Diabetes";

*Variable List;
  *Continuous;                    
  %let contvar =  FPG HbA1c HbA1cIFCC ;

  *Categorical;                   
  %let catvar  = HbA1c3cat HbA1cIFCC3cat FPG3cat DMMeds Diabetes diab3cat;

*Simple Data Listing & Summary Stats;
%simple;

  
**Validations********************************************************;

*Summary Statistics of HbA1C by HbA1C catogorization;
title2 "HbA1c categories check";
 proc means data=validation  maxdec=2 fw=8;
  class HbA1C3cat;
  var HbA1C;
  run;

*Summary Statistics of FPG by FPG catogorization;
title2 "HbA1c categories check";
 proc means data=validation  maxdec=2 fw=8;
  class FPG3cat;
  var FPG;
  run;

*Summary Statistics of HbA1CIFCC by HbA1CIFCC catogorization;
title2 "HbA1c categories check";
 proc means data=validation  maxdec=2 fw=8;
  class HbA1CIFCC3cat;
  var HbA1CIFCC;
  run;

*cross tabulation of categories of HbA1C;
PROC freq data=validation;
tables  HbA1C3cat*HbA1CIFCC3cat/missing;
run;

****************************************;
*Looking for quirks in the FPG calculation. More specifically, where FastHours >= 8 & not missing glucose:none;
proc print data = validation(where = (not missing(glucose) & missing(FPG) & hour(FastHours) >= 8));
  var subjid FastHours FPG;
  run;

*Validate Diabetes Definition;
title2 "Diabetes Vs. HbA1c3cat & FPG3ca & DMmeds";
proc freq data=validation;;
 tables Diabetes*DMMeds*HbA1c3cat*FPG3cat/ list missing;
 run;


*NOTE: The goal here is to see if A1c and FPG are providing similar dabetic classifications;
  title2 "FPG vs HbA1C  ";
proc gplot data = validation;
symbol1  pointlabel=none;
 plot FPG*HbA1c / vaxis=axis1 haxis = 3 to 18 by 0.5 href  = 5.7 6.5 vaxis = 30 to 520 by 20 vref  = 60 100 126;
   run; quit;

*Explore HbA1c vs Fasting Glucose by Fasting Glucose Categorization;
title2 "HbA1c vs FPG by FPG Category";
title3 "HbA1c Classified Normal";
proc gplot data = validation(where = (HbA1c3cat = 0));
symbol1  pointlabel=none;
 plot HbA1c*FPG = FPG3cat / vaxis=axis1  href = 60 100 126;
 run; quit;

title2 "HbA1c vs FPG by FPG Category";
title3 "HbA1c Classified Pre-Diabetic";
proc gplot data = validation(where = (HbA1c3cat = 1));
symbol1  pointlabel=none;
 plot HbA1c*FPG = FPG3cat / vaxis=axis1 vaxis=5.5 to 6.7 by 0.1 vref  = 5.7 href  = 60 100 126;
 run; quit;

title2 "HbA1c vs FPG by FPG Category";
title3 "HbA1c Classified Diabetic";
proc gplot data = validation(where = (HbA1c3cat = 2));
symbol1  pointlabel=none;
 plot HbA1c*FPG = FPG3cat / vaxis=axis1 vref  = 6.5 href  = 60 100 126;
 run; quit;


*Explore HbA1c vs Fasting Glucose by HbA1c Categorization;
title2 "HbA1c vs FPG by HbA1c Category";
title3 "FPG Classified Normal";
proc gplot data = validation(where = (FPG3cat = 0));
symbol1  pointlabel=none;
 plot HbA1c*FPG = HbA1c3cat / vaxis=axis1 vref  = 5.7 6.5 href  = 60 100;
 run; quit;

*Mark the outlier;
 data validation;
   set validation;
   if HbA1c>13.00 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_hf_n= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "HbA1c vs FPG by HbA1c Category";
title3 "FPG Classified At Risk";
proc gplot data = validation(where = (FPG3cat = 1));
 symbol1  pointlabel=("#outlier_text_hf_n" c=red h=1 );
plot HbA1c*FPG = HbA1c3cat / vaxis=axis1 vref  = 5.7 6.5 href  = 100 126;
 run; quit;

title2 "HbA1c vs FPG by HbA1c Category";
title3 "FPG Classified Diabetic";
proc gplot data = validation(where = (FPG3cat = 2));
symbol1  pointlabel=none;
 plot HbA1c*FPG = HbA1c3cat / vaxis=axis1 vref  = 5.7 6.5 href  = 126;
 run; quit;


*Explore HbA1c vs Fasting Glucose by Diabetes Classification;
title2 "FPG vs HbA1c by Diabetic Classification";
proc gplot data = validation;
symbol1  pointlabel=none;
 plot HbA1c*FPG=diabetes/ vaxis=axis1 vref  = 5.7 6.5 href  = 100 126;
 run; quit;

*Further Break down by Diabetic Meds;
 *Mark the outlier;
 data validation;
   set validation;
   if HbA1c>15.00 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_hf_med= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
title3 "Not on Diabetic Meds";
proc gplot data = validation(where = (DMMeds = 0));
 symbol1  pointlabel=("#outlier_text_hf_med" c=red h=1 );
 plot FPG*HbA1c = Diabetes / vaxis=axis1 vref = 60 100 126 href  = 5.7 6.5;
 run; quit;

title3 "On Diabetic Meds";
proc gplot data = validation(where = (DMMeds = 1));
 symbol1  pointlabel=none;
plot FPG*HbA1c = Diabetes / vaxis=axis1 vref  = 60 100 126 href  = 5.7 6.5;
 run; quit;


%put Section 06 Complete;
