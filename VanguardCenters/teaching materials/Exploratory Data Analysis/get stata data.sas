** Get JHS stata data for Exploratory Data Analysis class;

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
x 'cd teaching materials\EDA';

*set project data directory;
libname dat "data\1-data"; 

** read in formats from the JHS catalogue;
option fmtsearch=(analysis.formats jhsv1.v1formats);

****************************************************************
** 1) create dataset
***************************************************************;

*get data from JHS datasets;
  *analysis-ready;
  *proc contents data=analysis.analysis1; run;

  proc sort data = analysis.analysis1 out = datV1; by subjid; run;

*create analytic dataset;
data dat; set datV1(keep= CHDhx male HDL LDL trigs
						 currentSmoker age bmi bmi3cat
						 diabetes eGFR dbp Education
						 alc fpg sbp);
 ranuni=uniform(777);
 run;

 *select random N=500 & de-identify for teaching dataset;
proc sort data=dat; by ranuni; run;
data dat; set dat(obs=500); id=_n_; run;
data dat; merge dat(keep=id) dat(drop=id ranuni); run;
*proc print data=dat(obs=10); run;

*final changes for teaching dataset;
data dat; set dat;
	label id="Subject ID"
	      male="Gender==Male";

	rename alc=alcohol
		   currentSmoker=currsmoke;

    if hdl>100 then hdl=100;
  run; 

*export dataset to stata;
PROC EXPORT DATA= WORK.DAT 
            OUTFILE= "1-data\dat.dta" 
            DBMS=STATA REPLACE;
RUN;
*dont worry about the format error messages;

