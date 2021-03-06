********************************************************************;
******************** Section 4: Medications ************************;
********************************************************************;

title1 "Section 04: Medications";

*Produce basic statistics*******************************************;

*Variable List;

  *Continuous;                    
  %let contvar = ;

  *Categorical;                   
  %let catvar  = medAcct     BPmeds        BPmedsSelf     DMmedsOral  DMmedsIns  
                 DMMedType   DMMeds        statinMeds     hrtMeds     betaBlkMeds  
                 calBlkMeds  diureticMeds  antiArythMeds;	

*Simple Data Listing & Summary Stats;
%simple;

*Cross-tabs and other validations***********************************;
title2 "BPmeds vs BPmedsSelf";
proc freq data = validation;
  tables BPmeds*BPmedsSelf /missing;
  run;

title2 "DMMeds vs DMMedType";
proc freq data = validation;
  tables DMMeds*DMMedType /missing;
  run;
   
title2 "DMmedsoral vs DMMedType";
proc freq data = validation;
  tables DMmedsoral*DMMedType/MISSING ;
  run;
   
title2 "DMmedsins vs DMMedType";
proc freq data = validation;
  tables DMmedsins*DMMedType/MISSING ;
  run;

title2 "DMmedsoral vs DMMeds";
proc freq data = validation;
  tables DMmedsoral*DMMeds/MISSING ;
  run;

title2 "DMmedsins vs DMMeds";
proc freq data = validation;
  tables DMmedsins*DMMeds/MISSING ;
  run;


%put Section 04 Complete;
