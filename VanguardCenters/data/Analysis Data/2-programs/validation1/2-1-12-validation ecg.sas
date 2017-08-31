********************************************************************;
****************** Section 12: ECG **********************;
********************************************************************;

title1 "Section 12: ECG";
*Variable List;
  *Continuous;                    
  %let contvar = ecgHR QRS QT QTcFram QTcBaz QTcHod QTcFrid;

  *Categorical;                   
  %let catvar  = ConductionDefect MajorScarAnt    MinorScarAnt 	RepolarAnt MIAnt 
				 				 MajorScarPost    MinorScarPost   RepolarPost  	MIPost 
				 				 MajorScarAntLat  MinorScarAntLat RepolarAntLat MIAntLat  MIecg Afib Aflutter;

*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

*Examine distribution of ecgHR QRS QT;
proc univariate data=validation;
 var ecgHR QRS QT;
run;

*Validate MIecg definition;
 title2 "Check MIecg coding";
 *Creat indicator for the 3 components of MIecg to make the validation easier to understand*;
data validation;
 set validation;
 Major=sum(MajorScarAnt, MajorScarPost, MajorScarAntLat);
 if Major GE 1 then Major_1=1;else Major_1=Major;
 Minor=sum(MinorScarAnt, MinorScarPost, MinorScarAntLat);
 if Minor GE 1 then Minor_1=1;else Minor_1=Minor;
 Repolar=sum(RepolarAnt, RepolarPost, RepolarAntLat);
 if Repolar GE 1 then Repolar_1=1;else Repolar_1=Repolar;
 Label Major_1= "Major Scar from QnQs Wave Abnormality (Any Location)"
      Minor_1= "Minor Scar from QnQs Wave Abnormality (Any Location) "
      Repolar_1= "Repolarization Abnormality (Any Location)"
   ;
   run;
proc format;
   value yesnofmt 1="Yes"  0="No";
 run;


/*proc freq data = validation;
tables Major_1*Major*MajorScarAnt*MajorScarPost* MajorScarAntLat/list missing;
tables Minor_1*Minor*MinorScarAnt*MinorScarPost* MinorScarAntLat/list missing;
tables Repolar_1*Repolar*RepolarAnt*RepolarPost* RepolarAntLat/list missing;
run;*/;
Title2 'Validate the coding of MIecg';
proc freq data = validation;
 tables MIecg*ConductionDefect*Major_1*Minor_1*Repolar_1/list missing;
 format Major_1 yesnofmt. Minor_1 yesnofmt. Repolar_1 yesnofmt.;
 run;

*Cross tabulation of Afib and Aflutter;
title2 "Afib vs Aflutter";
proc freq data = validation;
 tables Afib*Aflutter /missing;
 run;

*Explore (QT QRS) vs. ecgHR;
ODS GRAPHICS/ANTIALIASMAX=5400 noscale width=6.5in height=10in;
title2 "QT QRS vs ecgHR ";
proc sgscatter data = validation;
 plot (QT QRS)*ecgHR/grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;

*Explore Corrected QTcs vs. ecgHR;
title2 "Corrected QTcs vs ecgHR";
proc sgscatter data = validation;
 plot (QTcFram QTcBaz)*ecgHR/grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;
proc sgscatter data = validation;
 plot (QTcHod QTcFrid)*ecgHR/grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
 run; quit;

*Explore Corrected QTcs vs. QT;
title2 "Corrected QTc vs QT";
proc sgscatter data = validation;
 plot (QTcFram QTcBaz)*QT/grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
run; quit;
proc sgscatter data = validation;
 plot (QTcHod QTcFrid)*QT/grid /*loess=(nogroup  LINEATTRS=(color='Red'))*/ columns=1 rows=2;
run; quit;

*Explore QT vs QRS;
 *Mark the outliers;
 data validation;
   set validation;
    if QT<300 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_QQ1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "QT vs QRS";
proc gplot data = validation;
 symbol2 v = circle h = 0.5 i = sm60s c=blue pointlabel=("#outlier_text_qq1" c=red h=1 );
 plot QT *QRS /vaxis = axis1 ;
 run; quit;

*Explore QTcFram vs ecgHR by gender;
 *Mark the outliers;
 data validation;
   set validation;
    if QTcFram<350 and ecgHR<40 then do;
  		outlier = 1; *indicator for outlier status;
		outlier_text_Qe1= cats("Outlier: ", subjid);
  	end;
  run; *proc print data=validation(where=(outlier=1)); run;

title2 "QTcFram vs ecgHR by gender";/*Female has higher(QTcFram) than male*/;
proc gplot data = validation;
 symbol2 v = circle h = 0.5 i = sm60s c=blue pointlabel=("#outlier_text_qe1" c=red h=1 );
 symbol1 v = circle h = 0.5 i = sm60s c=red  pointlabel=("#outlier_text_qe1" c=red h=1 );
 plot (QTcFram) *ecgHR=gender /vaxis = axis1 vref=450 470;
 run; quit;


%put Section 12 Complete;
