********************************************************************;
******************* Section 20: Environmental (derived geocoded)  ********************;
********************************************************************;

title "Section 20: Environmental (derived geocoded)";

*Variable List;
  *Continuous;                    
  %let contvar =  nbmedHHincome nbpctpoverty 
nbpctBlackNH nbpctWhiteNH nbSESpc2score nbSESanascore nbProblems
nbCohesion nbViolence nbK3FavorFoodstore nbK3paFacilities nbpctResiden1mi nbPopDensity1mi;

  *No categorical;                   
  %let catvar  = FakeCensusTractID;
*Simple Data Listing & Summary Stats;
%simple;

*Cross-tabs and other validations***********************************;

title2 "Summaries";
proc means data = validation maxdec = 2 fw = 6; 
 var nbmedHHincome nbpctpoverty nbpctBlackNH nbpctWhiteNH nbSESpc2score nbSESanascore nbProblems nbCohesion nbViolence nbK3FavorFoodstore nbK3paFacilities nbpctResiden1mi nbPopDensity1mi; run;

*Cross-tabs and other validations***********************************;
 *******************graphs********************************;
 *1. JHS Neighborhood Data;
title1 " JHS Neighborhood Data ";
title2 "Median household income vs. Percent of persons below poverty level in census tract";
proc sgscatter  data= validation; plot nbmedHHincome*nbpctpoverty ;  run;

 title2 "% black non-hispanic in Census Tract vs. % white non-hispanic in Census Tract";
proc sgscatter  data= validation; plot nbpctBlackNH*nbpctWhiteNH ;  run;

 title2 "% black non-hispanic in Census Tract vs. % below poverty in Census Tract";
proc sgscatter  data= validation; plot nbpctBlackNH*nbpctpoverty ;  run;

 title2 "Census Tract SES (PC2) Weighted Factor1 score in Census Tract vs. % below poverty in Census Tract";
proc sgscatter  data= validation; plot nbSESpc2score*nbpctpoverty ;  run;

 title2 "Census Tract SES (PC2) Weighted Factor1 score in Census Tract vs. Diez-Roux 1990 Census Tract SES score";
proc sgscatter  data= validation; plot nbSESpc2score*nbSESanascore;  run;

 title2 " Age & gender adjusted Unconditional Empirical Bayes Estimate (UEBE) for NB Problem PCA-based vs. Cohesion";
proc sgscatter  data= validation; plot nbProblems*nbCohesion;  run;

 title2 " Age & gender adjusted Unconditional Empirical Bayes Estimate (UEBE) for NB Problem PCA-based vs. Violence";
proc sgscatter  data= validation; plot nbProblems*nbViolence;  run;

title2 "3 mile kernel FAVORABLE FOOD STORES vs. 3 mile kernel TOTAL PHYSICAL ACTIVITIES+INSTRUCTIONAL+INSTRUCTIONAL+WATER";
proc sgscatter  data= validation; plot nbK3FavorFoodstore*nbK3paFacilities;  run;

 title2 "Percent Residential 1 mile vs. Population density per square mile  ";
proc sgscatter  data= validation; plot nbpctResiden1mi*nbPopDensity1mi;  run;


%put Section 20 Complete;
