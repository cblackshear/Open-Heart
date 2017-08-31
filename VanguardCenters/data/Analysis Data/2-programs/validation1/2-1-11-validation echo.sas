
********************************************************************;
****************** Section 11: ECHO **********************;
********************************************************************;

title1 "Section 11: ECHO";
*Variable List;
  *Continuous;                    
  %let contvar = LVMecho LVMindex EF DiastLVdia SystLVdia RWT;

  *Categorical;                   
  %let catvar  = /*LVdilation*/ LVH EF3cat FS /*LVgeometry*/;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

*see the summary of EF by EF categories;
title2 "the summary of EF by EF categories";
proc means data=validation;
class EF3cat;
var EF;run;

*see the summary of LVMindex by LVH categories;
title2 "the summary of LVMindex by LVH categories";
proc means data=validation;
class LVH;
var LVMindex;run;

*Cross tabulation of Ejection Fraction Categorization and Left Ventricular Hypertrophy
Categorization and Hypertension;
proc freq data=validation;
*tables LVdilation*LVH/missing;
 tables EF3cat*LVH/missing;
 tables EF3cat*HTN/missing;
 run;

/*
title2 'Check the coding of LVgeometry where RWT is not missing';;
proc freq data=validation;
where RWT ne .;
tables LVgeometry*LVdilation*LVH/list missing;
run;
*/
title2 ' ';
*Look at RWT and EF outlier closely based on the histogram from above*;
proc univariate data=validation;
 var RWT EF;run;

*Explore Left Ventricular Mass Indexed by Height(m)^2.7 vs Height;
*Mark the outliers;
 data validation;
   set validation;
    if LVMindex>105 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_lh1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "LVMindex vs.height";
proc gplot data = validation;
symbol1 pointlabel=("#outlier_text_lh1" c=red h=1 );;
 plot LVMindex*height/vaxis = axis1;
run; quit;

title2 "LVMindex vs.LVMecho";
proc gplot data = validation;
symbol1 pointlabel=("#outlier_text_lh1" c=red h=1 );;
 plot LVMindex*LVMecho/vaxis = axis1;
run; quit;

*Explore Diastolic LV Diameter (mm) vs. Systolic LV Diameter (mm) by Fractional Shortening Status;
*Mark the outliers;
 data validation;
   set validation;
    if SystLVdia<15 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_ds1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;


ODS GRAPHICS/ANTIALIASMAX=5400 noscale width=6.5in height=5in;
title2 "Diastolic LV Diameter (mm) vs. Systolic LV Diameter (mm) break down by FS status";
proc sgscatter data = validation;
 where FS ne .;
 plot DiastLVdia*SystLVdia /datalabel=outlier_text_ds1 group=FS grid loess=(nogroup  LINEATTRS=(color='Red'));
 run; quit;

********************************************;
*Explore M-mode diastolic IV septum thickness  (mm) vs. M-mode diastolic posterior wall thickness(mm);
ODS GRAPHICS/ANTIALIASMAX=5400 noscale width=6.5in height=5in;
title2 "M-mode diastolic IV septum thickness  (mm) vs. M-mode diastolic posterior wall thickness(mm)";
proc sgscatter data = validation;
 where FS ne .;
 plot diastlvst*diastwt /  grid loess=(nogroup  LINEATTRS=(color='Red'));
 run; quit;

 *Mark the outliers;
 data validation;
   set validation;
    if RWT>0.8 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_dR1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 " M-mode diastolic IV septum thickness(mm) vs. Relative Wall Thickness(RWT)";
proc sgscatter data = validation;
 where FS ne .;
 plot diastlvst*RWT /datalabel=outlier_text_dr1  grid loess=(nogroup  LINEATTRS=(color='Red'));
 run; quit;

title2 "M-mode diastolic posterior wall thickness(mm) vs. Relative Wall Thickness(RWT) ";
proc sgscatter data = validation;
 where FS ne .;
 plot diastwt*RWT /datalabel=outlier_text_dr1  grid loess=(nogroup  LINEATTRS=(color='Red'));
 run; quit;

title2 "Diastolic LV Diameter (mm) vs. Relative Wall Thickness(RWT)";
proc sgscatter data = validation;
 where FS ne .;
 plot DiastLVdia*RWT /datalabel=outlier_text_dr1  grid loess=(nogroup  LINEATTRS=(color='Red'));
 run; quit;

/*
proc sort data=validation out=workvalid;
by LVdilation;run;

axis1 label=(a=90);
title2 "DiastLVdia vs. RWT break down by LVH and LVdilation ";
proc gplot data = workvalid;
where LVdilation ne . and LVH ne .;
by LVdilation;
plot DiastLVdia*RWT=LVH/vaxis = axis1 href=0.32 0.42;
run; quit;
*/

%put Section 11 Complete;
