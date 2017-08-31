********************************************************************;
****************** Section 15: CVD History **********************;
********************************************************************;

title1 "Section 15: CVD History";

*Variable List;
  *Continuous;                    
  %let contvar = ;

  *Categorical;                   
  %let catvar  =  MIHx CardiacProcHx CHDHx CarotidAngioHx CVDHx;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

title2 'Cross-tabulation';
proc freq data=validation;
 tables MIHx*CardiacProcHx/list missing;
 tables MIHx*CHDHx/list missing;
 tables CVDHx*CHDHx*CarotidAngioHx*StrokeHx/list missing;*Check:3 pts reported CarotidAngioHx yes and CHDHx no*;
 tables CHDHx*CarotidAngioHx*StrokeHx/list missing;
 tables CHDHx*MIHx*MIecg/list missing;
run;

%put Section 15 Complete;
