********************************************************************;
****************** Section 17: Psychosocial **********************;
********************************************************************;

title1 "Section 17: Psychosocial";

*Variable List;
  *Continuous;                    
  %let contvar = dailyDiscr ;

  *Categorical;                   
  %let catvar  = fmlyinc /*income*/ education angerExpression angerIrritation
  				 angerInward angerGrudge rdiscrimReaction;

*Simple Data Listing & Summary Stats;
%simple;

%put Section 17 Complete;


*Cross-tabs between family income and education;
title2 "family income and education";
proc freq data=validation;
tables fmlyinc*education/missing;
run;


*Look at instances where visit 3 "highest education attained" is less than visit 1 "highest education attained";
	data check;
	merge
		analysis.validation1 (keep=subjid education rename=(education=educationV1) in=in1)
		validation (keep=subjid education rename=(education=educationV3) in=in2);
	by subjid;
	if in1 & in2;
	run;

	title2 "'Highest education attained' at Visit 1 vs. at Visit 3";
	proc freq data=check;run;
	where educationV3 < educationV1 & ^missing(educationV3);
	tables educationV1*educationV3 / list missing;
	run;
	/* Education discrepancies: N=486 */
