********************************************************************;
****************** Section 15: CVD History **********************;
********************************************************************;

title1 "Section 15: CVD History";

*Variable List;
  *Continuous;                    
  %let contvar = ;

  *Categorical;                   
  %let catvar  =  MIHx CardiacProcHx /*CHDHx*/ CarotidAngioHx CVDHx;*Not collected at visit 2*;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

title2 'Cross-tabulation';

proc freq data=validation;
tables MIHx*CardiacProcHx/missing;
tables CVDHx*CarotidAngioHx*StrokeHx/list missing;*Check:3 pts reported CarotidAngioHx yes and CHDHx no*;
tables CarotidAngioHx*StrokeHx/missing;
run;

%put Section 15 Complete;
