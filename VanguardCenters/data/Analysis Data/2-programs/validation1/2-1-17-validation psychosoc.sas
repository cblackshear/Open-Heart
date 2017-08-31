********************************************************************;
******************  Section 17: Psychosocial  **********************;
********************************************************************;

title1 "Section 17: Psychosocial";

*Variable List;
  *Continuous;                    
  %let contvar = dailyDiscr lifetimeDiscrm discrmBurden weeklyStress perceivedStress depression ;

  *Categorical;                   
  %let catvar  = fmlyinc Income Occupation  HSgrad edu3cat 	;       

*Simple Data Listing & Summary Stats;
%simple;


*Cross-tabs and other validations***********************************;
title2 "Summaries of Discrimination scores" ;
proc means data = validation maxdec = 2 fw = 6; 
 var dailyDiscr   lifetimeDiscrm     discrmBurden;
 run;

 title2 "Summaries of Stress Measures" ;
proc means data = validation maxdec = 2 fw = 6; 
 var weeklyStress  	 perceivedStress;
 run;

/* Under review
 title2 "Summaries of Depression Measure" ;
proc means data = validation maxdec = 2 fw = 6; 
 var cesd;
 run;
*/

 title2 "Overview of Family Income and SES Variables" ;
proc freq data=validation;
	table fmlyinc*income;
	table income*occupation;
	table income*edu3cat;
run;



%put Section 17 Complete;
