********************************************************************;
****************** Section 08: Biospecimens**********************;
********************************************************************;

title1 "Section 08: Biospecimens";
				  
*Variable List;
  *Continuous;                    
  %let contvar = hsCRP;*only collect hsCRP;

  *Categorical;                   
  %let catvar  =;

*Simple Data Listing & Summary Stats;
%simple;
 proc univariate data = validation ;
    var hsCRP;
    run;

*Try log transformation of continuous variables due to right skewed distribution*;
data validation;
set validation;
log_hsCRP=log(hsCRP);
run;

*Validations********************************************************;

*Examine Univariate distribution on transformed variable*;
proc univariate noprint data=validation;
histogram log_hsCRP;
run;

*No extreme high hsCRP:validation stop here*;

%put Section 08 Complete;
