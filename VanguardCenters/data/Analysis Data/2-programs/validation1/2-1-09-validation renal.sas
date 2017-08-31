********************************************************************;
****************** Section 09: Renal**********************;
********************************************************************;

title1 "Section 09: Renal";

*Variable List;
  *Continuous;                    
  %let contvar = SCrCC            SCrIDMS            	
                 eGFRmdrd         eGFRckdepi         
                 CreatinineU24hr 	CreatinineUSpot 
                 AlbuminU24hr    	AlbuminUSpot 
                 DialysisDuration;

  *Categorical;                   
  %let catvar  = DialysisEver ckdhx;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

Proc univariate data=validation noprint;
histogram eGFRmdrd eGFRckdepi CreatinineU24hr  CreatinineUSpot AlbuminU24hr AlbuminUSpot;
run;


*Try log transformation of continuous variables due to right skewed distribution*;
data validanalysis1;
set validation;
if AlbuminU24hr=0 then AlbuminU24hr=.;
log_Albumin24=log(AlbuminU24hr);
log_AlbuminUSpot=log(AlbuminUSpot);
log_SCrCC=log(SCrCC);
log_SCrIDMS=log(SCrIDMS);
run;

*Examine the histrogram after transformation;
Proc univariate data=validAnalysis1 noprint;
 histogram log_Albumin24 log_AlbuminUSpot log_SCrCC log_SCrIDMS SCrCC SCrIDMS;
run;

*Look at univariate distribution of transformed variables;
Proc univariate data=validAnalysis1;
 var log_Albumin24 log_AlbuminUSpot log_SCrCC log_SCrIDMS;
run;

*Explore Scr (CC) vs. eGFR (IDMS) by gender*;
title2 "SCr (CC) vs eGFR (MDRD) by Sex";
proc gplot data = validation;
 plot SCrCC*eGFRmdrd = sex /vaxis=axis1 href = 60 90;
 run; quit;

title2 "SCr (CC) vs eGFR (MDRD) by Sex";
proc gplot data = validAnalysis1;
 plot log_SCrCC*eGFRmdrd = sex /vaxis=axis1 href = 60 90;
 run; quit;

*Explore Scr (IDMS) vs. eGFR (CKD-Epi) by gender*;
title2 "SCr (IDMS) vs eGFR (CKD-Epi) by Sex";
proc gplot data = validation;
 plot SCrIDMS*eGFRckdepi = sex /vaxis=axis1 href = 60 90;
 run; quit;

title2 "SCr (IDMS) vs eGFR (CKD-Epi) by Sex";
proc gplot data = validAnalysis1;
 plot log_SCrCC*eGFRckdepi = sex /vaxis=axis1 href = 60 90;
 run; quit;

*Explore AlbuminUSpot vs. CreatinineUSpot;
title2 "AlbuminUSpot vs. CreatinineUSpot";
proc gplot data = validation;
 plot AlbuminUSpot*CreatinineUSpot /vaxis=axis1;
 run; quit;

 title2 "AlbuminUSpot(on the log scale) vs. CreatinineUSpot";
proc gplot data = validanalysis1;
symbol1  pointlabel=none;
plot log_AlbuminUSpot*CreatinineUSpot ;
 run; quit;

 *Mark the outlier;
 data validanalysis1;
   set validanalysis1;
   if CreatinineU24hr>4 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_ac1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

*Explore AlbuminU24hr vs. CreatinineU24hr;
title2 "AlbuminU24hr vs. CreatinineU24hr";
proc gplot data =validanalysis1;
 symbol1  pointlabel=("#outlier_text_ac1" c=red h=1 );
plot AlbuminU24hr*CreatinineU24hr /vaxis=axis1;
 run; quit;

 *Explore log_AlbuminU24hr vs. CreatinineU24hr;
title2 "log_AlbuminU24hr vs. CreatinineU24hr";
proc gplot data =  validanalysis1;
 symbol1  pointlabel=("#outlier_text_ac1" c=red h=1 );
plot log_Albumin24*CreatinineU24hr /vaxis=axis1;
 run; quit;
 
%put Section 09 Complete; 
