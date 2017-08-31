********************************************************************;
****************** Section 3: Anthropometrics **********************;
********************************************************************;

title1 "Section 03: Anthropometrics";

*Produce basic statistics*******************************************;

*Variable List;

  *Continuous;                    
  %let contvar = weight height BMI waist hip bsa;

  *Categorical;                   
  %let catvar  = OBESITY3cat;

*Simple Data Listing & Summary Stats;
%simple;

*Cross-tabs and other validations***********************************;

title2 "Summaries by BMI 3-level categories";
proc means data = validation maxdec = 2 fw = 6; 
 class bmi3cat;
 var bmi height weight waist bsa;
 run;

title2 "BMI: Check Outliers (max is > 90)";
proc univariate data = validation plots; 
  var bmi; 
  run;

 *Mark the outliers of BMI;
  data validation;
   set validation;
   if BMI>90 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_BMI3= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

proc sgplot data=validation;
where bmi3cat ne .;
title1;
title2 'Height vs. Weight by BMI Categorization';
xaxis label='Weight (kg)' ;*min=60 max=160;
yaxis label='Height (cm)' ;*min=150 max=190;
scatter x=weight y=height /datalabel=outlier_text_BMI3 group=bmi3cat markerattrs=(symbol=circlefilled size=3);
run;


proc sgplot data=validation;
where bmi3cat ne .;
title1;
title2 'Waist vs. Weight by BMI Categorization';
xaxis label='Weight (kg)' min=60 max=160;
yaxis label='Waist (cm)' min=60 max=200;
scatter x=weight y=waist / group=bmi3cat markerattrs=(symbol=circlefilled size=3);
run;

proc sgplot data=validation;
where bmi3cat ne .;
title1;
title2 'Hip vs. Weight by BMI Categorization';
xaxis label='Weight (kg)' min=60 max=160;
yaxis label='Hip (cm)' min=60 max=200;
scatter x=weight y=hip / group=bmi3cat markerattrs=(symbol=circlefilled size=3);
run;
 
title2 "Waist vs Hip by BMI Categorization";
proc sgplot data=validation;
where bmi3cat ne .;
title1;
title2 'Hip vs. Waist by BMI Categorization';
xaxis label='Waist(cm)' min=60 max=160;
yaxis label='Hip (cm)' min=60 max=200;
scatter x=waist y=hip / group=bmi3cat markerattrs=(symbol=circlefilled size=3);
run;

*Compare BMI and BSA;
title2 "Body Surface Area vs Body Mass Index for Males";
proc sgplot data = validation;
  where male = 1;
	reg x=bmi y=bsa / markerattrs=(symbol=trianglefilled size=3);
	loess x=bmi y=bsa / nomarkers;
run;

title2 "Body Surface Area vs Body Mass Index for Females";
proc sgplot data = validation;
  where male = 0;
	reg x=bmi y=bsa / markerattrs=(symbol=trianglefilled size=3);
	loess x=bmi y=bsa / nomarkers;
run;


%put Section 03 Complete;
