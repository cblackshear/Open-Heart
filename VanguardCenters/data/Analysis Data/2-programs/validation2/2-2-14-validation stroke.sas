********************************************************************;
****************** Section 14: Stroke History **********************;
********************************************************************;

title1 "Section 14: Stroke History";

*Variable List;
  *Continuous;                    
  %let contvar = ;
  *Categorical;                   
  %let catvar  = speechLossEver VisionLossEver DoubleVisionEver NumbnessEver ParalysisEver 
								 DizzynessEver  strokeHX;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

*Cross tabulation of Self-reported indication of physician-diagnosed stroke
and self-report symptoms;
proc freq data=validation;
 tables strokeHX*ParalysisEver/missing;
 tables strokeHX*speechLossEver/missing;
 tables strokeHX*VisionLossEver/missing;
 tables strokeHX*DoubleVisionEver/missing;
 tables strokeHX*NumbnessEver/missing;
 tables strokeHX*DizzynessEver/missing;
 run;

%put Section 14 Complete;
