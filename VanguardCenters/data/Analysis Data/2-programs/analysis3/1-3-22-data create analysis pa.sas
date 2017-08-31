********************************************************************;
***********     Section 22:  Physical Activity     ***********;
********************************************************************;

title "Section 22: Physical Activity ";

*Physical Activity Working Group;
data include ;
  set ssn0007.derivedpa (keep = subjid acl03 HFY03 SPT03);
  by subjid;

  *Create renamed duplicates for formulas;
  sportIndex   = SPT03;
  hyIndex      = HFY03;
  activeIndex  = acl03;
  run;

*Format and label variables ***************************************************;
data include; *Create variables;
  set include; 
  by subjid; 

  *Variable: sportIndex;
  label  sportIndex = "Sport Index";
  format sportIndex 8.2;

  *Variable: hyIndex;
  label  hyIndex = "Home/Yard Index";
  format hyIndex  8.2;

  *Variable: activeIndex;
  label  activeIndex = "Active Living Index";
  run;

*Add to Analysis Dataset;
data analysis; *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
  if in1 = 1; *Only keep clean ptcpts;
  run;

  /*Checks;
  proc contents data = analysis; run;
  proc print data = analysis(obs = 5); run;
  */

 *Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep22pa = subjid sportIndex hyIndex activeIndex;             

%put Section 22 Complete;
