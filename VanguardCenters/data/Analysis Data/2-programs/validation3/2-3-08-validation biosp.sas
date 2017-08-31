********************************************************************;
****************** Section 08: Biospecimens**********************;
********************************************************************;

title1 "Section 08: Biospecimens";
				  
*Variable List;
  *Continuous;                    
  %let contvar = hsCRP eSelectin pSelectin; *only collect hsCRP;

  *Categorical;                   
  %let catvar  = ;

*Simple Data Listing & Summary Stats;
%simple;

*Try log transformation of continuous variables due to right skewed distribution*;
data validation;
set validation;
log_hsCRP=log(hsCRP);
log_eSelectin=log(eSelectin);
log_pSelectin=log(pSelectin);
run;

*Examine Univariate distribution on transformed variable*;
proc univariate noprint data=validation;
histogram log_hsCRP log_eSelectin log_pSelectin;
run;

 title2 "hsCRP vs. eSelectin";
proc gplot data=validation;
symbol1  pointlabel=none;
plot log_hsCRP* log_eSelectin /vaxis=axis1;
 run;quit;

%put Section 08 Complete;
