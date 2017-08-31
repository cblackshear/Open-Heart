********************************************************************;
****************** Section 13: CT Imaging **********************;
********************************************************************;

title1 "Section 13: CT Imaging";

*Variable List;
  *Continuous;                    
   %let contvar = VAT50mm SAT50mm CAC AAC;

   *Categorical;                   
   %let catvar  = anyCAC anyAAC;

*Simple Data Listing & Summary Stats;
%simple;


*Validations********************************************************;

*Cross-Tabulation of Agatston Coronary Calcification > 0 by Agatston Aortic Artery Calcification > 0;
title2 'Table of anyCAC by anyAAC';
Proc freq data=validation;
 tables anyCAC*anyAAC/missing;
 run;
 *Summary statistics of CAC by CAC categorization;
 title2 "Summary statistics of CAC by CAC categorization";
proc means data=validation;
class anyCAC;
var CAC;RUN;

 title2 "Summary statistics of AAC by AAC categorization";
proc means data=validation;
class anyAAC;
var AAC;RUN;

*Log transform Total Agatston Score All Coronary and AAC;
data validation2_1;
 set validation;
 if CAC=0 then CAC=.;
 if AAC=0 then AAC=.;
 log_CAC=log(CAC);
 log_AAC=log(AAC);
 run;

*Examine the Distribution and Histogram on the Log Scale;
proc univariate data=validation2_1;
var log_CAC log_AAC;
histogram log_CAC log_AAC;
run;



*Explore VAT50mm vs.SAT50mm;
title2 "VAT50mm vs.SAT50mm  ";
proc gplot data = validation;
symbol1 pointlabel=none;
plot VAT50mm*SAT50mm/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

title2 "VAT50mm vs.SAT50mm  ";
title3 "VAT50mm vs.SAT50mm by gender";
proc gplot data = validation;
 symbol1 v = circle h =1 i = sm60s cv = blue ci = blue;
 symbol2 v = circle h =1 i = sm60s cv = red  ci =red;
plot VAT50mm*SAT50mm=male/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

*Explore Agatson Coronary Score vs. Agatston Score aorto-iliacs;
 *Mark the outlier;
 data validation;
   set validation;
   if CAC>10000 then do;
      outlier=1;*indicator for outlier status;
		outlier_text_ca= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs';
proc gplot data = validation;
 symbol1   pointlabel=("#outlier_text_ca" c=red h=1 );
 plot CAC*AAC/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

title2 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs';
title3 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs by gender';
proc gplot data = validation;
 symbol1 v = circle h =1 i = sm60s cv = blue ci = blue  pointlabel=("#outlier_text_ca" c=red h=1 );
 symbol2 v = circle h =1 i = sm60s cv = red  ci =red  pointlabel=("#outlier_text_ca" c=red h=1 );
 plot CAC*AAC=male/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

title2 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs (on log scale)';
proc gplot data = validation2_1;
 symbol1 v = circle h =1 i = sm60s cv = red ci = blue pointlabel=none;
 plot log_CAC*Log_AAC/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

title2 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs (on log scale)';
title3 ' Agatson Coronary Score vs. Agatston Score aorto-iliacs (on log scale) by gender';
proc gplot data = validation2_1;
 symbol1 v = circle h =1 i = sm60s cv = blue ci = blue pointlabel=none;
 symbol2 v = circle h =1 i = sm60s cv = red  ci =red pointlabel=none;
 plot log_CAC*Log_AAC=male/ vaxis=axis1; *vaxis = 3 to 18 by 1 vref  = 5.7 6.5 haxis = 30 to 520 by 50 href  =100 126*;
 run; quit;

%put Section 13 Complete;

 

