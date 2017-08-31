
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
 *Mark the outlier;
 data validation;
   set validation;
   if ldl>300 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_tl= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
title2 "total chol vs ldl";
proc gplot data=validation;
 where NOT missing(ldl5cat);
 symbol1  pointlabel=("#outlier_text_tl" c=red h=1 );
plot totchol*ldl=ldl5cat 
       / vaxis=axis1
         href=100 130 160 190
         vref=200 240;
    run; quit;

*Explore Total Cholesterol vs hdl by hdl Categorization;
	*Further break down by gender;
 *Mark the outlier;
 data validation;
   set validation;
   if totchol>350 and hdl<30 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_th_m= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "total chol vs hdl: Male";
proc gplot data=validation (where=(male=1));
 where NOT missing(hdl3cat);
 symbol1  pointlabel=("#outlier_text_th_m" c=red h=1 );
plot totchol*hdl=hdl3cat 
       / vaxis=axis1
         href=40 60
         vref=200 240;
    run; quit;

title2 "total chol vs hdl: Female";
  proc gplot data=validation (where=(male=0));
   where NOT missing(hdl3cat);
   symbol1  pointlabel=none;
 plot totchol*hdl=hdl3cat 
       /vaxis=axis1 
         href=50 60
         vref=200 240;
    run; quit;

*Explore Total Cholesterol vs Trigs by Trigs Categorization; 
*Mark the outlier;
 data validation;
   set validation;
   if trigs>3000 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_tt= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "total chol vs trigs";
proc gplot data=validation;
 where NOT missing(trigs4cat);
 symbol1  pointlabel=("#outlier_text_tt" c=red h=1 );
 plot totchol*trigs=trigs4cat 
       / vaxis=axis1
        href=150 200 500
         vref=200 240;
 run; quit;

*Explore hdl vs ldl by ldl Categorization;
*Mark the outlier;
 data validation;
   set validation;
   if ldl>300 and hdl<30 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_lh= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
title2 "hdl vs ldl";
proc gplot data=validation;
 where NOT missing(ldl5cat);
 symbol1  pointlabel=("#outlier_text_lh" c=red h=1 );
plot hdl*ldl=ldl5cat 
       / vaxis=axis1
         href=100 130 160 190
         vref=40 50 60;
 run; quit;

*Explore Trigs vs ldl by ldl Categorization;
 *Mark the outlier;
 data validation;
   set validation;
   if ldl>300 and trigs<150 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_lt= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "trigs vs ldl";
proc gplot data=validation;
 where NOT missing(ldl5cat);
  symbol1  pointlabel=("#outlier_text_lt" c=red h=1 );
plot trigs*ldl=ldl5cat 
       /vaxis=axis1
         href=100 130 160 190
         vref=150 200;
    run; quit;


%put Section 07 Complete;

