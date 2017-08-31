********************************************************************;
****************** Section 5: Hypertension *************************;
********************************************************************;

title1 "Section 05: HTN";

*Variable List:                                  
  *Continuous;  
  %let contvar = sbp dbp; 

  *Categorical; 
  %let catvar  = sbpHTN dbpHTN BPjnc7 BPmeds BPmedsSelf HTN;

*Simple Data Listing & Summary Stats;
  %simple;

*Validations********************************************************;
proc means data = validation;
class sbpHTN;
var sbp;
run;

proc means data = validation;
class dbpHTN;
var dbp;
run;

*Validate BP Classification and HTN classification;
proc freq data=validation;
title2"BPjnc7 Category Vs. HTN";
table htn*bpjnc7;
run;

*Validate BP Classification and systolic(diastolic) bp classification;
title2 "BPjnc7 Category Vs.SBP and Dbp";
proc freq data = validation;
 tables BPjnc7 /missing;
 tables BPjnc7*sbpHTN /missing;
 tables BPjnc7*dbpHTN /missing;  
 run;


*Validate Hypertension Classification and BP Classification and meds;
PROC SORT data = validation; by HTN; run;

title2 "HTN category vs BP Classification and meds";
proc freq data = validation;
 tables  BPjnc7*BPmedsSelf /missing;
 by HTN;
run;


*Explore Systolic bp vs. Diastolic bp;
*mark the outlier ;
  data validation;
   set validation;
   if sbp>210 and dbp<50 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_sd= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "sbp vs dbp";
proc gplot data = validation;
symbol1  pointlabel=("#outlier_text_sd" c=red h=1 );
 plot sbp*dbp /vaxis=axis1;
 run; quit;

*Explore Systolic bp vs. Diastolic bp by BP Classification; 
 *mark the outlier ;
  data validation;
   set validation;
   if sbp>100 and dbp<40 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_sd_nomed= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
*Not on BP meds; 
title2 "BPjnc7: Not On BP Meds";
proc gplot data = validation(where = (BPmedsSelf = 0));
symbol1  pointlabel=("#outlier_text_sd_nomed" c=red h=1 );
 plot dbp*sbp = BPjnc7 /  vaxis=axis1 haxis = 60 to 240 by 20
                           vref  = 80 90 100 href  = 120 140 160;
 run; quit;

*On BP meds;
  *mark the outlier ;
  data validation;
   set validation;
   if sbp>200 and dbp<50 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_sd_med= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;
title2 "BPjnc7: On BP Meds";
 proc gplot data = validation(where = (BPmedsSelf = 1));
 symbol1  pointlabel=("#outlier_text_sd_med" c=red h=1 );
  plot dbp*sbp = BPjnc7 / vaxis=axis1  haxis = 60 to 240 by 20
                             vref  = 80 90 100 href  = 120 140 160;
  run; quit;
  
*Explore Systolic bp vs. Diastolic bp by HTN Classification; 
*Not on BP meds; 
 title2 "HTN: Not On BP Meds";
proc gplot data = validation(where = (BPmedsSelf = 0));
symbol1  pointlabel=("#outlier_text_sd_nomed" c=red h=1 );
 plot dbp*sbp = HTN /  vaxis=axis1 haxis = 60 to 240 by 20
                           vref  =90 href  =140;
 run; quit;

*On BP meds;
title2 "HTN: On BP Meds";
 proc gplot data = validation(where = (BPmedsSelf = 1));
 symbol1  pointlabel=("#outlier_text_sd_med" c=red h=1 );
  plot dbp*sbp = HTN / vaxis=axis1  haxis = 60 to 240 by 20
                             vref  = 80 90 100 href  = 120 140 160;
  run; quit;


%put Section 05 Complete;

