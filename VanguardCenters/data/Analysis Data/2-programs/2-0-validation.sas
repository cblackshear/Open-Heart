*********************** Jackson Heart Study ************************;
*************** Set global options and define macro ****************;
********************************************************************;
	
*Macro for simple statistics;
%macro simple; *Macro for simple statistics;

  *Set up global statements for graphs*;
    goptions reset = all;
    ods graphics /reset = all;
    axis1 label = (a = 90);
    symbol1 v = dot h = 0.3;
    title2 h = 12pt;
  
    %let cat  = %scan(&catvar,  1);
    %let cont = %scan(&contvar, 1);

  *When we have categorical vars only*******************************;
  %if (&cont = ) %then
    %do;
      *Print first 5 obs of dataset;
      title2 "Simple data listing (first 5 obs)";
      proc print data = validation(obs = 5) noobs;
        var subjid &catvar;
        run;

      *Summary statistics for cat vars;
      title2 "Univariate summary stats: categorical";
      proc freq data = validation;
       tables &catvar /missing;
       run;
      %end;

  *When we have continuous vars only********************************;
  %if (&cat = ) %then
    %do;
      *Print first 5 obs of dataset;
      title2 "Simple data listing (first 5 obs)";
      proc print data = validation(obs = 5) noobs;
        var subjid &contvar;
        run;

      *Summary statistics for cont vars;
      title2 "Univariate summary stats: continuous";
      proc means data = validation n nmiss mean std min max maxdec = 2 fw = 8; 
        var &contvar; 
        run;

      *Histograms for cont vars;
      proc univariate data = validation noprint;
        histogram &contvar;
        run;
      %end;

  *When we have categorical and continuous vars*********************;
  %if ((&cont ne ) & (&cat ne )) %then
    %do;
      *Print first 5 obs of dataset;
      title2 "Simple data listing (first 5 obs)";
      proc print data = validation(obs = 5) noobs;
        var subjid &contvar &catvar;
        run;

      *Summary statistics for cat vars;
      title2 "Univariate summary stats: categorical";
      proc freq data = validation;
       tables &catvar /missing;
       run;

      *Summary statistics for cont vars;
      title2 "Univariate summary stats: continuous";
      proc means data = validation n nmiss mean std min max maxdec = 2 fw = 8; 
        var &contvar; 
        run;

      *Histograms for cont vars;
      proc univariate data = validation noprint;
        histogram &contvar;
        run;
      %end;

  title2;

%mend;

%put;
%put;
%put Simple Statistics Macro Read in Successfully;
%put;
%put;
