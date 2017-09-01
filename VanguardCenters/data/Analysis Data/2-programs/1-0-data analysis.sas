*Clear work directory;
options nonotes;
ods results off;
  proc datasets lib = work kill memtype = data; run; quit;
ods results on;
options notes;
%put -Ignore warning if work library is empty-;

*Read in macro;
  %macro reshape();
    options nonotes;
    ods results off;

    data analysisWide;
      set cohort.visitdat(keep = subjid); * initialize dataset, use just subject ID;
      run;

    data analysisLong;
      set analysisLong;
      if visit = 1 then visitTag = "V1"; *reformat the visitTag variable for id statement in proc transpose;
      if visit = 2 then visitTag = "V2";
      if visit = 3 then visitTag = "V3";
      run;

    %let i = 1; * start the counter at 1;
    %let var = %scan(&variables, &i); * picks off the i^th variable out of the list &variables;

    %do %while(&var ne ); * do loop ends when we are out of variables;

      proc transpose data = analysisLong out = &var prefix = &var; * reshape from long to wide - prefix keeps name of variable;
        id visitTag; * what SAS appends to the end of the prefix;
        by subjid; * one observation per subjid;
        var &var; * what variable to transpose;
        run;

      data &var;
        set &var;
        drop _NAME_ _LABEL_; * drop the name and label for ease in merging;
        run;

      data analysisWide;
        merge analysisWide
              &var; * append new dataset onto the wide dataset;
        by subjid; * merge by subjid;
        run;

      proc datasets library = work memtype = data;    
        delete &var; * housekeeping - delete vars wide dataset since we have already appended it to the overall wide dataset;
        run;

      %let i   = %eval(&i + 1); * increase counter;
      %let var = %scan(&variables, &i); * pick off next variable for reshaping;

      %end;

   ods results on;
   options notes;
  %mend reshape;

