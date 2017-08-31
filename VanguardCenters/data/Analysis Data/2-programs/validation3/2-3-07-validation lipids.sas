
********************************************************************;
****************** Section 7: Lipids **********************;
********************************************************************;

title1 "Section 07: Lipids";

*Variable List;
  *Continuous;  

  %let contvar = ldl hdl trigs totchol;

  *Categorical;                   
  %let catvar  = ldl5cat hdl3cat trigs4cat totchol3cat;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

*Examine the Distribution of Triglycerides;
proc univariate data=validation;
 var trigs;
run;

*Summary Statistics of ldl by ldl Categorization;
title2 "LDL categories check";
proc means data=validation  maxdec=2 fw=8;
  class ldl5cat;
  var ldl;
  run;

*Summary Statistics of hdl by Gender and hdl Categorization;
title2 "HDL categories check";
proc means data=validation  maxdec=2 fw=8;
  class male hdl3cat;
  var hdl;
  run;

*Summary Statistics of Triglycerids by Triglycerids Categorization;
title2 "Trigs categories check";
proc means data=validation  maxdec=2 fw=8;
  class trigs4cat;
  var trigs;
  run;

*Summary Statistics of Total Cholesterol by Cholesterol Categorization; 
title2 "Total Chol categories check";
proc means data=validation  maxdec=2 fw=8;
  class totchol3cat;
  var totchol;
  run;

*Cross Tabulation of Categories of Lipids;
proc freq data=validation;
 tables totchol3cat*hdl3cat/missing;
 tables totchol3cat*ldl5cat/missing;
 tables totchol3cat*trigs4cat/missing;
 tables ldl5cat*hdl3cat/missing;
 tables trigs4cat*hdl3cat/missing;
 tables ldl5cat*hdl3cat/missing;
 run;

*Explore Total Cholesterol vs ldl by ldl Categorization;

proc sort data=validation;
by ldl5cat;
run;

proc sgplot data=validation;
where ldl5cat ne .;
title2 "Total Cholesterol vs. LDL";
scatter x=ldl y=totchol / group=ldl5cat markerattrs=(symbol=circlefilled size=3);
refline 100 / axis=x lineattrs=(thickness=1 color=black);
refline 130 / axis=x lineattrs=(thickness=1 color=black);
refline 160 / axis=x lineattrs=(thickness=1 color=black);
refline 190 / axis=x lineattrs=(thickness=1 color=black);
refline 200 / axis=y lineattrs=(thickness=1 color=black);
refline 240 / axis=y lineattrs=(thickness=1 color=black);
run;

*Explore Total Cholesterol vs hdl by hdl Categorization;
	*Further break down by gender;

proc sort data=validation;
by hdl3cat;
run;

proc sgplot data=validation;
where hdl3cat ne . and male=1;
title2 "Total Cholesterol vs. HDL for Males";
scatter x=hdl y=totchol / group=hdl3cat markerattrs=(symbol=circlefilled size=3);
refline 40 / axis=x lineattrs=(thickness=1 color=black);
refline 60 / axis=x lineattrs=(thickness=1 color=black);
refline 200 / axis=y lineattrs=(thickness=1 color=black);
refline 240 / axis=y lineattrs=(thickness=1 color=black);
run;

proc sgplot data=validation;
where hdl3cat ne . and male=0;
title2 "Total Cholesterol vs. HDL for Females";
scatter x=hdl y=totchol / group=hdl3cat markerattrs=(symbol=circlefilled size=3);
refline 50 / axis=x lineattrs=(thickness=1 color=black);
refline 60 / axis=x lineattrs=(thickness=1 color=black);
refline 200 / axis=y lineattrs=(thickness=1 color=black);
refline 240 / axis=y lineattrs=(thickness=1 color=black);
run;

proc sort data=validation;
by trigs4cat;
run;

*Explore Total Cholesterol vs Trigs by Trigs Categorization;
*Mark the outliers;
  data validation;
   set validation;
   if trigs>800 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_tt3= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

proc sgplot data=validation;
where trigs4cat ne .;
title2 "Total Cholesterol vs. Triglycerides";
scatter x=trigs y=totchol /datalabel=outlier_text_tt3 group=trigs4cat markerattrs=(symbol=circlefilled size=3);
refline 150 / axis=x lineattrs=(thickness=1 color=black);
refline 200 / axis=x lineattrs=(thickness=1 color=black);
refline 500 / axis=x lineattrs=(thickness=1 color=black);
refline 200 / axis=y lineattrs=(thickness=1 color=black);
refline 240 / axis=y lineattrs=(thickness=1 color=black);
run;


*Explore hdl vs ldl by ldl Categorization;

proc sort data=validation;
by ldl5cat;
run;

proc sgplot data=validation;
where ldl5cat ne .;
title2 "HDL vs. LDL";
scatter x=ldl y=hdl / group=ldl5cat markerattrs=(symbol=circlefilled size=3);
refline 100 / axis=x lineattrs=(thickness=1 color=black);
refline 130 / axis=x lineattrs=(thickness=1 color=black);
refline 160 / axis=x lineattrs=(thickness=1 color=black);
refline 190 / axis=x lineattrs=(thickness=1 color=black);
refline 40 / axis=y lineattrs=(thickness=1 color=black);
refline 50 / axis=y lineattrs=(thickness=1 color=black);
refline 60 / axis=y lineattrs=(thickness=1 color=black);
run;

*Explore Trigs vs ldl by ldl Categorization;

proc sgplot data=validation;
where ldl5cat ne .;
title2 "Triglycerides vs. LDL";
scatter x=ldl y=trigs / group=ldl5cat markerattrs=(symbol=circlefilled size=3);
refline 100 / axis=x lineattrs=(thickness=1 color=black);
refline 130 / axis=x lineattrs=(thickness=1 color=black);
refline 160 / axis=x lineattrs=(thickness=1 color=black);
refline 190 / axis=x lineattrs=(thickness=1 color=black);
refline 150 / axis=y lineattrs=(thickness=1 color=black);
refline 200 / axis=y lineattrs=(thickness=1 color=black);
run;

%put Section 07 Complete;
