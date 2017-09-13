** Program/project map for JHS: HDL vs Age project (example code);

** We Note that we use all data in the example below
** Numeric results are somewhat different than in published 
** manuscript due to inclusion \ exclusion criteria etc.

*set system options like do not center or put a date on output, etc.;
options nocenter nodate nonumber ps=150 linesize=100;
options nofmterr;

* assign root directory (VanguardCenters);
****************************************************
* YOU MUST CHANGE THIS TO YOUR DIRECTORY STRUCTURE!:
****************************************************;
* Example: x 'cd C:\JHS\VanGuardCenters';
*x 'cd C:\...\VanGuardCenters';
x 'cd C:\Users\cblackshear\Box Sync\JHSCCDC\1-StudyData\VCworking\VanguardCenters';

*Set Vanguard Center JHS V1 data dir (relative to the root VanguardCenters Directory);
libname analysis "data\Analysis Data\1-data"; 
libname jhsV1    "data\Visit 1\1-data"; 

*assign project directory;
x 'cd example projects\Harman 2011 - HDL vs Age';
*set project data directory;
libname dat "1-data"; 

** read in formats from the JHS catalogue;
option fmtsearch=(analysis.formats jhsv1.v1formats);

****************************************************************
** 1) create dataset: select & combine appropriate JHS datasets
****************************************************************

	*** Visit 1 Data ***;
	*proc contents data=analysis.analysis1; run;

	 *v1 data;
	 data analysis1; set analysis.analysis1;
	  keep subjid hdl age male trigs alc waist height sbp dbp hscrp;
    rename alc=etoh_use;
      run;
	 *proc print data=analysis1(obs=5); run;
	 *proc contents data=analysis1; run;

	  *v1 Central Laboratory Data;
	 data cena; set jhsV1.cena;
	  keep subjid hscrp cortisol;
	  rename cortisol=SCortisol;
	  run;

	  *v1 Local Laboratory Data;
	 data loca; set jhsV1.loca;
	  keep subjid uric_acid;
	  rename uric_acid=uricacid;
	  run;

	*v1 dietary data;
	data dita; set jhsV1.dita;
	  keep subjid DITA34 DITA136;
	  rename DITA34=VitD dita136=pctcalcarb;
	  run;

	*v1 stress data;
	data stsa; set jhsV1.stsa;
	  keep subjid stsa1;
	  rename stsa1=jobstress;
	  run;



	*merge;
  proc sort data = analysis1; by subjid; run;
	data datv1JHSnames; merge analysis1 /*antv sbpa*/ cena loca dita stsa; by subjid; run;
	  *proc contents data=datv1JHSnames; run;

	*save dataset with JHS variable names to project data directory;
	data dat.datv1JHSnames; set datv1JHSnames; run;


	*create reduced V1 data with analysis variable names;
	data datv1; set datv1JHSnames;
	  keep subjid age male waist hdl trigs pctcalcarb etoh_use;
		run;

	*create  analytic dataset;
	data dat; set datv1; 
	  lnTG=log(trigs);
	  lnwaist =log(waist);
	  run;

	*save analytic dataset to project data directory;
	data dat.dat; set dat; run;


************************************************************
** 2) EDA: Exploratory Data Analyses (not shown for example)
************************************************************
*(removed for the example, too much code)

************************************************************
** 3) Initial Modeling explorations 
************************************************************
*(removed for the example)


************************************************************
** 4) Items included in actual paper;
************************************************************

*read in anlytic dataset;
data dat; set dat.dat; run;

* Table 1: Baseline Characteristics (example);
proc means data=dat maxdec=2;
  class male;
  var HDL age trigs waist pctcalcarb;
  run;
 
** Table 2: Primary Model Results;
*proc contents data=dat; run;
proc genmod data=dat;
  class etoh_use;
  model HDL=age male age*male lnTG lnwaist pctcalcarb etoh_use;
  *model HDL=age male age*male lnTG lnwaist pctcalcarb etoh_use physact_90_num;
  *repeated subject=sibid / type=exch corrw;
  estimate "Female Age Slope" age 1;
  estimate "Male Age Slope" age 1 age*male 1;
  estimate "Difference" age*male 1;
  run;

*** Figure 1: Data and Trajectories - by male; *(simple version);
goptions reset=all;
symbol1 v=dot h=.3 i=sm65s c=red  ci=red line=1 w=2;
symbol2 v=dot h=.3 i=sm65s c=blue ci=blue line=1 w=2;
proc gplot data=dat;
  plot HDL*age=male;
  run; quit;
goptions reset=all;

**************************************************************************************;
*** Figure 1: Data and Trajectories - by male;
* Added Variable Plot (AVP);
*       HDL vs age plot, adjusted for other covariates;
* Goal: regression is: E(Y) = b0 + b1X + b2V1 + b3*V2 + ... 
*       where X is primary predictor and V1-V_k. are "adjustors";
* 	Make a plot of relationship between Y & X, adjusted for V1-V_k.
*Steps:;
*Step 1) remove effects of adjusters (V1-V_k) on outcome -> get residual = resy;
*Step 2) remove effects of adjusters (V1-V_k) on predictor (X) -> get residual = resx;
*Step 3) Plot resy vs resx shows adj relationship (AVP);
**************************************************************************************;

*Step 1) remove effects of adjusters on outcome> get residual = resy;
proc genmod data=dat;
  class etoh_use;
  model HDL=lnTG lnwaist pctcalcarb etoh_use;
  output out=resy resraw=resy;
  run;

*Step 2) remove effects of adjusters on predictor > get residual = resx;
proc genmod data=dat;
  class etoh_use;
  model Age=lnTG lnwaist pctcalcarb etoh_use;
  output out=resx resraw=resx;
  run;

*Step 3) Plot resy vs resx;
*combine residual data: (& rescale to natural scale);
*get average age & HDL;
proc means data=dat; var age hdl; run;
*construct simple plotting dataset;
data plotdat; merge resy resx; by subjid; 
  y = resy+51.77; *add back in mean HDL to rescale residual to natural scale;
  x = resx+54.87; *add back in mean Age to rescale residual to natural scale;
  if not missing(male) then do;
  	if male=1 then yM=y; else yF=y;
  end;
  run;

*get fits & CIs for plot;
proc genmod data=plotdat;
  model y=x male x*male;
  output out=pred pred=yhat lower=lcl upper=ucl;
  run;
*set up upper and lower polygon to fill from ucl & lcl;
  proc sort data=pred out=poly1; by x; run;
  proc sort data=pred out=poly2; by descending x; run;
* combine into polygon plotting dataset;
data poly; set poly1(rename=(ucl=CI)) 
			  poly2(keep=lcl x male rename=(lcl=CI)); 
  if not missing(male) then do;
  	if male=1 then do; 
		yhatM=yhat; CIm=CI;
	end;
	else do;
		yhatF=yhat; CIf=CI;
	end;
  end;  
  run;

***********************************************;
*  Final figure: export to RTF document as well;
***********************************************;
ods rtf file="3-results\Figure1.rtf";
	goptions reset=all;
	symbol1 i=ms c=pink;
	symbol2 i=ms c=lightblue;
	symbol3 v=dot h=.1 i=sm99s c=red ci=red line=1 w=2;
	symbol4 v=dot h=.1 i=sm99s c=blue ci=blue line=1 w=2;
	legend1 label=NONE across=1 
		value=(font=swiss h=2 "Female" "Male") 
	    position=(inside top left) offset=(1cm) mode=protect;
	axis1 label=(angle=90 font=arial h=2 "HDL (Adjusted)") 
		value=(font=arial h=1.5) minor=none
		order=(20 to 120 by 10);
	axis2 label=(font=arial h=2 "Age (Adjusted)")  
		value=(font=arial h=1.5) minor=none
		order=(35 to 75 by 10);
	proc gplot data=poly;
	  plot CIf*x CIm*x  
		/ overlay vaxis=axis1 haxis=axis2 nolegend;
	  plot2 yF*x yM*x / vaxis=axis1 overlay noaxes legend=legend1;
	  run; quit;
ods rtf close;
