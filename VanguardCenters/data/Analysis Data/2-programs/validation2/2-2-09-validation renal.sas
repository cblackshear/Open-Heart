********************************************************************;
****************** Section 09: Renal**********************;
********************************************************************;
title1 "Section 09: Renal";

*Variable List;
  *Continuous;                    
  %let contvar = CreatinineUSpot 
                 AlbuminUSpot 
                 DialysisDuration;

  *Categorical;                   
  %let catvar  = DialysisEver ckdhx;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

Proc univariate data=validation ;
 var CreatinineUSpot  AlbuminUSpot ;
 run;

*Try log transformation of continuous variables due to right skewed distribution*;
data validation;
set validation;
log_CreatinineUSpot=log(CreatinineUSpot);
log_AlbuminUSpot=log(AlbuminUSpot);
run;

*Examine the univariate distribution and histrogram after transformation;
Proc univariate data=validation;
var log_CreatinineUSpot log_AlbuminUSpot;
histogram  log_CreatinineUSpot  log_AlbuminUSpot ;
run;

 
*Explore AlbuminUSpot vs. CreatinineUSpot;
*Mark the outlier;
 data validation;
   set validation;
   if CreatinineUSpot>600 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_ac= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "AlbuminUSpot vs. CreatinineUSpot";
proc gplot data = validation; 
symbol1  pointlabel=("#outlier_text_ac" c=red h=1 );
 plot AlbuminUSpot*CreatinineUSpot ;
 run; quit;

title2 "AlbuminUSpot(on the log scale) vs. CreatinineUSpot";
proc gplot data = validation;
symbol1  pointlabel=("#outlier_text_ac" c=red h=1 );
plot log_AlbuminUSpot*CreatinineUSpot  ;
 run; quit;


%put Section 09 Complete; 
