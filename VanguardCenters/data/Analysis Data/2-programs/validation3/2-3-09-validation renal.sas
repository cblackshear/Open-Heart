********************************************************************;
****************** Section 09: Renal**********************;
********************************************************************;
title1 "Section 09: Renal";

*Variable List;
  *Continuous;                    
  %let contvar = CreatinineUSpot AlbuminUSpot DialysisDuration
				         SCrIDMS            	
                 eGFRmdrd        eGFRckdepi;

  *Categorical;                   
  %let catvar  = DialysisEver ckdhx;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

Proc univariate data=validation;
var eGFRckdepi  CreatinineUSpot  AlbuminUSpot;
histogram eGFRckdepi  CreatinineUSpot AlbuminUSpot;
run;

*Try log transformation of continuous variables due to right skewed distribution*;
data validanalysis1;
set validation;
log_AlbuminUSpot=log(AlbuminUSpot);
log_SCrIDMS=log(SCrIDMS);
run;

*Examine the histrogram after transformation;
Proc univariate data=validAnalysis1 noprint;
 histogram log_AlbuminUSpot log_SCrIDMS;
run;

*Look at univariate distribution of transformed variables;
Proc univariate data=validAnalysis1;
 var log_AlbuminUSpot log_SCrIDMS;
run;

*Explore SCr vs. eGFR by gender*;
*Mark the outliers;
   data validanalysis1;
   set validanalysis1;
   if eGFRckdepi>300 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_es3= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
proc sgplot data=validanalysis1;
title2 "SCr (IDMS) vs eGFR (CKD-Epi) by Sex";
scatter x=eGFRckdepi y=SCrIDMS /datalabel=outlier_text_es3 group=sex markerattrs=(symbol=circlefilled size=3);
refline 60 / axis=x lineattrs=(thickness=1 color=black);
refline 90 / axis=x lineattrs=(thickness=1 color=black);
run;

proc sgplot data=validanalysis1;
title2 "log_SCr (IDMS) vs eGFR (CKD-Epi) by Sex";
scatter x=eGFRckdepi y=log_SCrIDMS /datalabel=outlier_text_es3 group=sex markerattrs=(symbol=circlefilled size=3);
refline 60 / axis=x lineattrs=(thickness=1 color=black);
refline 90 / axis=x lineattrs=(thickness=1 color=black);
run;

*Mark the outliers;
   data validanalysis1;
   set validanalysis1;
   if CreatinineUSpot>680 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_ca3= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
*Explore AlbuminUSpot vs. CreatinineUSpot;
 proc sgplot data=validanalysis1;
title2 "AlbuminUSpot vs. CreatinineUSpot";
scatter x=CreatinineUSpot y=AlbuminUSpot /datalabel=outlier_text_ca3 markerattrs=(symbol=circlefilled color=red size=3);
run;

*Explore log_AlbuminUSpot vs. CreatinineUSpot;
 proc sgplot data=validanalysis1;
title2 "log_AlbuminUSpot vs. CreatinineUSpot";
scatter x=CreatinineUSpot y=log_AlbuminUSpot /datalabel=outlier_text_ca3 markerattrs=(symbol=circlefilled color=red size=3);
run;
%put Section 09 Complete; 
