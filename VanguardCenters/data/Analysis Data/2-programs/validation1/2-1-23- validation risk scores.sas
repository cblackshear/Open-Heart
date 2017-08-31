********************************************************************;
********************* Section 23: Risk Scores **********************;
********************************************************************;

title1 "Section 23: Risk Scores";

*Merge validation data set with   dataset, which contains parental history of heart disease variable;
data validation; set analysis.validation1;run;
data A; set jhsv1.pfha;run;

*Sort before merging;
proc sort data=validation; by subjid;run;
proc sort data=A; by subjid;run;

*merge validation dataset with pfha dataset;
data validation;
	merge validation (in=in1) A;
	by subjid;
	if in1=1;
run;

*Create family history of heart disease variable;
data validation; set validation;
  parhistheartdis= . ;
  if pfha21a="Y" | pfha30a="Y" /*| pfhb28a=1 | pfhb37a=1*/ then parhistheartdis=1; 
  else parhistheartdis=0;
run;


 *Validations********************************************************;

*Print first 5 obs of dataset;
      title2 "Simple data listing (first 5 obs)";
      proc print data = validation(obs = 5) noobs;
        var subjid frs_chdtenyrrisk frs_cvdtenyrrisk frs_atpiii_tenyrrisk rrs_tenyrrisk ascvd_tenyrrisk;
        run;title2; quit;

*Means of risk scores;
	  title2 "Univariate summary stats: continuous";
      proc means data = validation n nmiss mean std min max maxdec = 2 fw = 8; 
        var frs_chdtenyrrisk frs_cvdtenyrrisk frs_atpiii_tenyrrisk rrs_tenyrrisk ascvd_tenyrrisk; 
        run;title2;quit;
		

*Histograms for frs_chdtenyrrisk;
      proc univariate data = validation noprint;
        histogram frs_chdtenyrrisk;
        run;
      *create data set that has underlying risk score attributes;
	  data frs_chdtenyrriskOutliers;
	    set validation;
		*informat frs_chdtenyrrisk;
 	    where frs_chdtenyrrisk >= 0.56;
 		keep subjid sex age totchol hdl sbp diabetes currentsmoker frs_chdtenyrrisk;
		title1 'Particicpants with frs_chdtenyrrisk score >= 0.56';
		proc sort data=frs_chdtenyrriskOutliers; by frs_chdtenyrrisk;
		proc print data=frs_chdtenyrriskOutliers;
	  	run;title1;quit;

*Histograms for frs_cvdtenyrrisk;
      proc univariate data = validation noprint;
        histogram frs_cvdtenyrrisk;
        run;
	  *create data set that has underlying risk score attributes;
	  data frs_cvdtenyrriskOutliers;
		set validation;
 		where frs_cvdtenyrrisk >= 0.615;
		keep subjid sex age totchol hdl sbp bpmeds diabetes currentsmoker frs_cvdtenyrrisk;
		title1 'Participants with frs_cvdtenyrrisk score >= 0.615';
	  proc sort data=frs_cvdtenyrriskOutliers; by frs_cvdtenyrrisk; 
	  proc print data=frs_cvdtenyrriskOutliers;
	  run;title1;quit;

 *Histograms for frs_atpiii_tenyrrisk;
      proc univariate data = validation noprint;
        histogram frs_atpiii_tenyrrisk;
      run;
	  *create data set that has underlying risk score attributes;
	  data frs_atpiii_tenyrriskOutliers;
 		set validation;
 		where frs_atpiii_tenyrrisk >= 0.30;
 		keep subjid sex age totchol hdl sbp bpmeds currentsmoker frs_atpiii_tenyrrisk;
		title1 'Participants with frs_atpiii_tenyrrisk score >= 0.30';
	  proc sort data=frs_atpiii_tenyrriskOutliers; by frs_atpiii_tenyrrisk;
	  proc print data=frs_atpiii_tenyrriskOutliers;
	  run;title1;quit;

 *Histograms for rrs_tenyrrisk;
      proc univariate data = validation noprint;
        histogram rrs_tenyrrisk;
      run;
	  *create data set that has underlying risk score attributes;
	  data rrs_tenyrriskOutliers;
 		set validation;
 		where rrs_tenyrrisk >= 0.60;
 		keep subjid sex age totchol hdl sbp diabetes currentsmoker rrs_tenyrrisk;
		title1 'Participants with rrs_tenyrrisk score >= 0.60';
	  proc sort data=rrs_tenyrriskOutliers; by rrs_tenyrrisk;
	  proc print data=rrs_tenyrriskOutliers;
	  run;title1;quit;

 *Histograms for ascvd_tenyrrisk;
      proc univariate data = validation noprint;
        histogram ascvd_tenyrrisk;
      run;
	  *create data set that has underlying risk score attributes;
	  data ascvd_tenyrriskOutliers;
		set validation;
 		where ascvd_tenyrrisk >= 0.66;
 		keep subjid sex age totchol hdl sbp bpmeds diabetes currentsmoker ascvd_tenyrrisk;
		title1 'Participants with ascvd_tenyrrisk score >= 0.66';
	  proc sort data=ascvd_tenyrriskOutliers; by ascvd_tenyrrisk; 
 	  proc print data=ascvd_tenyrriskOutliers;
 	  run;title1;quit;


******Obtaining ROC and AUC;

*frs_chdtenyrrisk;
ods select none;
proc logistic data=validation;
	 class diabetes currentsmoker sex;
	 model CHDHx(event='Yes')=age totchol hdl sbp diabetes currentsmoker sex;
	 score data=validation out=sco_validate;
run;
quit;

*frs_cvdtenyrrisk;
ods select none;
proc logistic data=validation;
	class currentsmoker sex diabetes bpmeds;
	model CHDHx(event='Yes')=age totchol hdl sbp diabetes currentsmoker sex bpmeds;
	score data=validation out=sco_validate;
run;
quit;

*frs_atpiii_tenyrrisk;
ods select none;
proc logistic data=validation;
   class currentsmoker sex bpmeds;
   model CHDHx(event='Yes')=age totchol hdl sbp currentsmoker sex bpmeds;
   score data=validation out=sco_validate;
run;
quit;

*rrs_tenyrrisk;
ods select none;
proc logistic data=validation ;
   class diabetes currentsmoker sex parhistheartdis;
   model CHDHx(event='Yes')=age totchol hdl sbp diabetes currentsmoker sex hscrp HbA1c parhistheartdis;
   score data=validation out=sco_validate;
run;
quit;

*ascvd_tenyrrisk;
ods select none;
proc logistic data=validation;
	class bpmeds currentsmoker sex diabetes;
	model CHDHx(event='Yes')=age totchol hdl sbp bpmeds currentsmoker sex diabetes;
	score data=validation out=sco_validate;
run;
quit;

*ROC curves with all 5 scores;
ods select ROCOverlay;
proc logistic data=sco_validate plots=roc(id=prob);
	model CHDHx(event='Yes')= frs_chdtenyrrisk frs_cvdtenyrrisk frs_atpiii_tenyrrisk rrs_tenyrrisk ascvd_tenyrrisk/ nofit;  *no fit is used to prevent proc logistc from fitting model with 4 covariates;
	roc "Framingham CHD Ten Year Risk" frs_chdtenyrrisk;
	roc "Framingham CVD Ten Year Risk" frs_cvdtenyrrisk;
	roc "Framingham ATPIII Ten Year Risk" frs_atpiii_tenyrrisk;
	roc "Reynolds Risk Score Ten Year Risk" rrs_tenyrrisk;
	roc "ACC AHA ASCVD 10 Year Risk" ascvd_tenyrrisk;
	roccontrast "Area under the curve for all 5 risk prediction models"/estimate=allpairs;
run;


******Scatter plot matrix of all risk scores;
proc sgscatter data=validation;
matrix frs_chdtenyrrisk frs_cvdtenyrrisk frs_atpiii_tenyrrisk rrs_tenyrrisk ascvd_tenyrrisk;
title "Scatter Plot Matrix of all Risk Scores";
run;

%put Section 23 Complete;
