********************************************************************;
******************* Section 18: Life's Simple 7 ********************;
********************************************************************;

title "Section 18: Life's Simple 7";

*Variable List;
  *Continuous;                    
  %let contvar = ;

  *No categorical;                   
  %let catvar  = BMI3cat  totChol3cat  BP3cat  glucose3cat; 

*Simple Data Listing & Summary Stats;
%simple;

%put Section 18 Complete;
