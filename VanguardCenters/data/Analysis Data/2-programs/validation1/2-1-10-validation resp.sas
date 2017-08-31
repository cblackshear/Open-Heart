********************************************************************;
****************** Section 10: Respiratory**********************;
********************************************************************;
title1 "Section 10: Respiratory";

*Variable List;
  *Continuous;                    
  %let contvar = maneuvers FVC FEV1 FEV6 FEV1PP FVCPP;

  *Categorical;                   
  %let catvar  = asthma;

*Simple Data Listing & Summary Stats;
%simple;


*Validations********************************************************;

*Check formulas for FEV1PP and FVCPP. The values should not be over 100%;
proc univariate data=validation ;
var FEV1PP FVCPP;
 run;
*Validate asthma definition;
proc freq data=validation;
 tables everHadAsthma confirmedAsthma stillHaveAsthma /missing;
 tables asthma*everHadAsthma*confirmedAsthma*stillHaveAsthma/list missing;
 run;

*Explore FEV1 FEV6 vs FVC;
 *Mark the outliers;
 data validation;
   set validation;
    if fvc<1 and (FEV1>=5 or FEV6>8)then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_ff1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

ODS GRAPHICS/ANTIALIASMAX=5400 noscale width=6.5in height=10in;
title2 "FEV1 FEV6 vs FVC ";
proc sgscatter data = validation;
  plot (FEV1 FEV6)*FVC/datalabel= outlier_text_ff1 grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;

*Explore FEV6 vs.FEV1;
title2 "FEV6 vs FEV1";
proc gplot data = validation;
 symbol1 v = circle h = 0.5 i = sm60s cv = blue ci = red pointlabel=("#outlier_text_ff1" c=red h=1 );;
 plot FEV6*FEV1 /vaxis = axis1;
 run; quit;

*Explore FEV1pp vs.FEV1 break down by gender;
 *Mark the outliers;
 data validation;
   set validation;
    if FEV1pp>220 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_fpf1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
title2 "FEV1pp vs FEV1 by Sex";
proc gplot data = validation;
 symbol1 v = circle h = 0.5 i = sm60s cv = blue ci = blue  pointlabel=("#outlier_text_fpf1" c=red h=1 );
 symbol2 v = circle h = 0.5 i = sm60s cv = black  ci = red   pointlabel=("#outlier_text_fpf1" c=red h=1 );
 plot FEV1pp*FEV1 = sex /vaxis = axis1;
 run; quit;

*Explore FEV1_pred vs.FEV1 break down by gender;
title2 "FEV1 Predicted vs FEV1 by Sex";
proc gplot data = validation;
 symbol1 v = circle h = 0.5 i = sm60s cv = blue ci = blue pointlabel=none;
 symbol2 v = circle h = 0.5 i = sm60s cv = plack  ci = red pointlabel=none;
 plot FEV1_pred*FEV1 = sex /vaxis = axis1;
 run;quit;

*Explore FVCpp vs FVC break down by gender;
 *Mark the outliers;
 data validation;
   set validation;
    if fvc>9 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_fvcf1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "FVCpp vs FVC by Sex";
proc gplot data = validation;
 symbol1 v = circle h = 0.5 i = sm60s cv = blue  ci = blue pointlabel=("#outlier_text_fvcf1" c=red h=1 );
 symbol2 v = circle h = 0.5 i = sm60s cv = black ci = red  pointlabel=("#outlier_text_fvcf1" c=red h=1 );
 plot FVCpp*FVC = sex /vaxis = axis1;
 run; quit;

*Explore FVC Predicted vs FVC break down by gender;
title2 "FVC Predicted vs FVC by Sex";
proc gplot data = validation;
 symbol1 v = circle h = 0.5 i = sm60s cv = blue ci = blue pointlabel=("#outlier_text_fvcf1" c=red h=1 );
 symbol2 v = circle h = 0.5 i = sm60s cv = black ci = red pointlabel=("#outlier_text_fvcf1" c=red h=1 );
 plot FVC_pred*FVC = sex /vaxis = axis1;
 run; quit;




%put Section 10 Complete;

