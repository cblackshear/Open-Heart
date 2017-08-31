
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

*Look at triglycerides;
proc univariate data=validation;
 var trigs;
run;
*NOTE: Some of the ranges in the CENA07.pdf codebook were not the same as given by SAS
       after dataset construction; 

*Check fasting hours;
title2 "Check fasting hours";
proc means data=validation;
 where (NOT missing(ldl)) |
        (NOT missing(hdl)) |
        (NOT missing(trigs)) |
        (NOT missing(totchol));
 var fasthours;
 run;

*Summary statistics of ldl by ldl Categorization;
title2 "LDL categories check";
proc means data=validation  maxdec=2 fw=8;
  class ldl5cat;
  var ldl;
  run;

*Summary statistics of hdl by gender and hdl categorization;
title2 "HDL categories check";
proc means data=validation  maxdec=2 fw=8;
  class male hdl3cat;
  var hdl;
  run;

*Summary statistics of triglycerids by triglycerids Categorization;
title2 "Trigs categories check";
proc means data=validation  maxdec=2 fw=8;
  class trigs4cat;
  var trigs;
  run;

*Summary statistics of total cholesterol by cholesterol Categorization; 
title2 "Total Chol categories check";
proc means data=validation  maxdec=2 fw=8;
  class totchol3cat;
  var totchol;
  run;

*Cross tabulation of categories of lipids;
proc freq data=validation;
 tables totchol3cat*hdl3cat/missing;
 tables totchol3cat*ldl5cat/missing;
 tables totchol3cat*trigs4cat/missing;
 tables ldl5cat*hdl3cat/missing;
 tables trigs4cat*hdl3cat/missing;
 tables ldl5cat*hdl3cat/missing;
 run;
	 

*Explore total cholesterol vs ldl by ldl Categorization;  
title2 "total chol vs ldl";
proc gplot data=validation;
 where NOT missing(ldl5cat);
 plot totchol*ldl=ldl5cat 
       / vaxis=axis1
         href=100 130 160 190
         vref=200 240;
    run; quit;

*Explore total cholesterol vs hdl by hdl categorization;
*Further break down by gender;
*Mark the outliers;
data validation;
   set validation;
   if hdl>130 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_th1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "total chol vs hdl: Male";
proc gplot data=validation (where=(male=1));
 where NOT missing(hdl3cat);
 symbol1  pointlabel=("#outlier_text_th1" c=red h=1 );
plot totchol*hdl=hdl3cat 
       / vaxis=axis1
         href=40 60
         vref=200 240;
    run; quit;

title2 "total chol vs hdl: Female";
  proc gplot data=validation (where=(male=0));
   where NOT missing(hdl3cat);
  symbol1  pointlabel=("#outlier_text_th1" c=red h=1 );
  plot totchol*hdl=hdl3cat 
       /vaxis=axis1 
         href=50 60
         vref=200 240;
    run; quit;

*Explore total cholesterol vs trigs by trigs categorization;
*Mark the outliers;
data validation;
   set validation;
   if trigs>2000 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_tt1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "total chol vs trigs";
  proc gplot data=validation;
    where NOT missing(trigs4cat);
	 symbol1  pointlabel=("#outlier_text_tt1" c=red h=1 );
    plot totchol*trigs=trigs4cat 
       / vaxis=axis1
        href=150 200 500
         vref=200 240;
    run; quit;

*Explore hdl vs ldl by ldl categorization;
*Mark the outliers;
data validation;
   set validation;
   if ldl>350 and hdl<20 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_hl1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "hdl vs ldl";
  proc gplot data=validation;
    where NOT missing(ldl5cat);
   symbol1  pointlabel=("#outlier_text_hl1" c=red h=1 );
   plot hdl*ldl=ldl5cat 
       / vaxis=axis1
         href=100 130 160 190
         vref=40 50 60;
    run; quit;

*Explore trigs vs ldl by ldl Categorization;
 *Mark the outliers;
data validation;
   set validation;
   if ldl>350  then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_tl1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "trigs vs ldl";
  proc gplot data=validation;
    where NOT missing(ldl5cat);
   symbol1  pointlabel=("#outlier_text_tl1" c=red h=1 );
    plot trigs*ldl=ldl5cat 
       /vaxis=axis1
         href=100 130 160 190
         vref=150 200;
    run; quit;


%put Section 07 Complete;
