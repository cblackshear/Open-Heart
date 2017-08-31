 *********************************************************************;
************** Section 20: Environmental (derived geocoded)**********;
*********************************************************************;
title "Section 20: Environmental (derived geocoded)";

*jhs_nb_analytic_long;
data include;
  set asn0023.jhs_nb_analytic_long (keep=subjid exam Fake_STCOTRK
inc_medHH Pov race_blackNH race_whiteNH F1_PC2 factor_ana
NPPCA_UEBE SCPCA_UEBE VOPCA_UEBE K3FAV K3PAI PRES1 POPDENMI1);
by subjid;
if exam="exam2";
run;

*create variables;
data include;
set include;
by subjid;

*Variable: FakeCensusTractID ;
FakeCensusTractID=Fake_STCOTRK;
 label  FakeCensusTractID = "Fake census tract ID";

*Variable:nbmedHHincome; 
nbmedHHincome=inc_medHH;
label nbmedHHincome="Median Household Income in Census Tract";
 format  nbmedHHincome 8.2;

*Variable:nbpctpoverty;
nbpctpoverty=Pov;
label nbpctpoverty="% Below Poverty in Census Tract";
 format nbpctpoverty  8.2;

*Variable:nbpctBlackNH;
nbpctBlackNH= race_blackNH;
label nbpctBlackNH="% Black Non-Hispanic in Census Tract";
 format  nbpctBlackNH 8.2;

*Variable:nbpctWhiteNH;
nbpctWhiteNH= race_whiteNH;
label nbpctWhiteNH="% White Non-Hispanic in Census Tract";
 format nbpctWhiteNH  8.2;

*Variable: nbSESpc2score;
nbSESpc2score=F1_PC2;
label  nbSESpc2score="Census Tract SES Score (PC2)";
 format  nbSESpc2score  8.2;

*Variable: nbSESanascore;
nbSESanascore= factor_ana;
label  nbSESanascore="Census Tract SES Score (Diez-Roux 1990)";
 format  nbSESanascore  8.2;

*Variable: nbProblems;
nbProblems =NPPCA_UEBE; 
label  nbProblems="Neighborhood Problems (Age & Sex Adj.)";
 format nbProblems  8.2;

*Variable: nbCohesion;
nbCohesion= SCPCA_UEBE;
label  nbCohesion="Neighborhood Social Cohesion (Age & Sex Adj.)";
 format  nbCohesion  8.2;

*Variable: nbViolence;
nbViolence =VOPCA_UEBE;
label  nbViolence="Neighborhood Violence (Age & Sex Adj.)";
 format  nbViolence 8.2;

*Variable: nbK3FavorFoodstore;
nbK3FavorFoodstore=K3FAV;
label  nbK3FavorFoodstore="Favorable Food Stores (3 Mile Kernel)";
 format  nbK3FavorFoodstore 8.2;


*Variable: nbK3paFacilities;
nbK3paFacilities=K3PAI;
label  nbK3paFacilities="Physical Activity Facilities (3 Mile Kernel)";
 format nbK3paFacilities  8.2;

*Variable: nbpctResiden1m;
nbpctResiden1mi=PRES1;
label  nbpctResiden1mi="Percent Residential Land Use per Square Mile";
 format nbpctResiden1mi  8.2;

*Variable: nb1mPopDensity;
nbPopDensity1mi=POPDENMI1;
label  nbPopDensity1mi="Population Density per Square Mile";
 format  nbPopDensity1mi 8.2;

run;

*Add to Analysis Dataset;
data analysis;
 *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
    if in1 = 1; *Only keep clean ptcpts;
  run;

    /*Checks;
  proc contents data = analysis; run;
  proc print data = analysis(obs = 5); run;
  */

   *Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep20geocode= FakeCensusTractID nbmedHHincome nbpctpoverty 
nbpctBlackNH nbpctWhiteNH nbSESpc2score nbSESanascore nbProblems
nbCohesion nbViolence nbK3FavorFoodstore nbK3paFacilities nbpctResiden1mi nbPopDensity1mi
 ;             
 
%put Section 20 Complete;
