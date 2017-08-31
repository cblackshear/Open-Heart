
********************************************************************;
****************** Section 08: Biospecimens**********************;
********************************************************************;

title1 "Section 08: Biospecimens";

*Variable List;
  *Continuous;                    
  %let contvar = hsCRP endothelin sCort reninRIA reninIRMA aldosterone leptin adiponectin;

  *No categorical;                   
  %let catvar  = ; 
*Simple Data Listing & Summary Stats;
%simple;

*pSelectin,eSelectin were not collected at visit 1*;
*Try log transformation of continuous variables due to right skewed distribution*;
data validanalysis1;
set validation;
if hsCRP=0 then hsCRP=.;
log_hsCRP=log(hsCRP);
log_endothelin=log(endothelin);
log_adiponectin=log(adiponectin);
log_sCort=log(sCort);
log_reninRIA=log(reninRIA);
log_reninIRMA=log(reninIRMA);
log_aldosterone=log(aldosterone);
log_leptin=log(leptin);
run;

%let contvar = log_hsCRP  log_endothelin  log_sCort log_reninRIA log_reninIRMA log_aldosterone  
               log_leptin log_adiponectin;

*Validations********************************************************;

*Examine histogram of those transformed variables*;
proc univariate data=validanalysis1 noprint;
 histogram &contvar;
 run;
*Look at univariate distribution of transformed variabless;
proc univariate data=validanalysis1;
 var &contvar;
 run;
*Investiage extreme high hsCRP*;
*Explore hsCRP and other biomakers*;

*Mark the outliers;
 data validation;
   set validanalysis1;
   if hsCRP>30 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_crp1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

ODS GRAPHICS/ANTIALIASMAX=5400 noscale width=6.5in height=10in;
title2  "endothelin sCort renin  vs.hsCRP ";
proc sgscatter data = validation;
  plot (endothelin sCort renin   )*log_hsCRP/datalabel= outlier_text_crp1 grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;
 title2  " aldosterone leptin adiponectin vs.hsCRP ";
proc sgscatter data = validation;
  plot (aldosterone leptin adiponectin )*log_hsCRP/datalabel= outlier_text_crp1 grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;

*Explore adiponectin vs. Leptin;
title2 "adiponectin vs.leptin";
proc gplot data=validation;
symbol1  pointlabel=none;
plot adiponectin*leptin /vaxis=axis1;
 run;quit;

*Explore sCort vs. aldosterone; 
 *Mark the outliers;
 data validation;
   set validation;
   if aldosterone>150 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_sa1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 h=12pt "sCort* aldosterone";
proc gplot data=validation;
 symbol1  pointlabel=("#outlier_text_sa1" c=red h=1 );
plot sCort*aldosterone /vaxis=axis1;
 run;quit;

%put Section 08 Complete;
