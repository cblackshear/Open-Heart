
********************************************************************;
********* Section 1: Design, Study-Level and Other Items ***********;
********************************************************************;

title1 "Section 1: Design, Study-Level, and Other Items";

*Produce basic statistics*******************************************;

*Variable List;

  *Continuous;                    
  %let contvar = VisitDate DaysFromV1 YearsFromV1 FastHours;

  *Categorical;                   
  %let catvar  = ARIC recruit;

*Simple Data Listing & Summary Stats;
%simple;

*Cross-tabs and other validations***********************************;

title2 "Visit Date: Min and Max";

*Print formatted min and max dates;

  title2 "Visit Date: Min and Max";
proc means data = validation min max; 
  var VisitDate;
run;

proc print data = validation noobs;
  var subjid VisitDate;
  where VisitDate = 17954 | VisitDate = 19389;
run;

title2 "YearsFromV1 vs. DaysFromV1";
proc corr data=validation;
  var YearsFromV1 DaysFromV1;
run;

title2 "Fasting Hours: Check negative, zero, and missing values";
proc print data = validation noobs;
  where FastHours <= 0;
  var subjid 
      FHhr FHmin;
run;
*Check the outlier of fasthours;
  data validation;
   set validation;
   if fasthours>40 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_fh3= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title "Fasthours vs. visitdate";
proc gplot data = validation;
symbol1  pointlabel=("#outlier_text_fh3" c=red h=1 );
  plot fasthours*visitdate; 
  run;quit;

 

proc sgplot data=validation;
 title2 'Visit Date vs. Days from Visit 1';
xaxis label='Visit Date';
yaxis label='Days from Visit 1';
scatter x=visitdate y=daysfromV1 / markerattrs=(symbol=circlefilled size=3);
run;

title2 "ARIC/JHS vs Recruitment Type";
proc freq data = validation;
  tables ARIC*recruit /missing;
  run;


title1 "Section 1: Design, Study-Level, and Other Items";

%put Section 01 Complete;

