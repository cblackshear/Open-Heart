********************************************************************;
********* Section 1: Design, Study-Level and Other Items ***********;
********************************************************************;

title "Section 1: Design, Study-Level and Other Items";

*FTRD;
data include1; *FTRD;
  set jhsV3.ftrd(keep = subjid ftrd5a ftrd5b);
  by subjid;

  *Create renamed duplicates for formulas;
  FHhr  = ftrd5a;    
  FHmin = ftrd5b;    
  run;

*PLKA;
data include2; *PLKA;
  set jhsV1.plka(keep = subjid plka1);
  by subjid;

  *Create renamed duplicates for formulas;
  recruitType = plka1;
  run;

*ANALYSIS;
data include3; *ANALYSIS;
  set analysis(keep = subjid V1date V3date);

  *Create renamed duplicates for formulas;
  visitDate = V3date;
  run;

*ELGA;
data include4; *ELGA;
  set splmnt.elga(keep = subjid elga5a);
  by subjid;

  *Create renamed duplicates for formulas;
  dob = elga5a;
  format dob mmddyy10.;
  run;

*PEDIGREE;
data include5; *PEDIGREE;
  set jhsV1.pedigree(keep = subjid family_id);
  by subjid;

  *Create renamed duplicates for formulas;
  familyid = family_id;
  run;

*Combine datasets sequentially;
*Combine 1 & 2;
data include; *Combine 1 & 2;
  merge include1(in = in1)
        include2(in = in2);
  by subjid;
    inc1 = in1;
    inc2 = in2;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Combine 1-2 & 3;
data include; *Combine 1-2 & 3;
  merge include(in = in1)
        include3(in = in2);
  by subjid;
    inc1 = in1;
    inc2 = in2;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Combine 1-3 & 4;
data include; *Combine 1-3 & 4;
  merge include(in = in1)
        include4(in = in2);
  by subjid;
    inc1 = in1;
    inc2 = in2;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Combine 1-4 & 5;
data include; *Combine 1-4 & 5;
  merge include(in = in1)
        include5(in = in2);
  by subjid;
    inc1 = in1;
    inc2 = in2;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Create variables;
data include; *Create variables;
  set include;
  by subjid;

  *Variable: VisitDate;
  VisitDate = V3date;
  label  VisitDate = "Date of Visit";
  format VisitDate MMDDYY10.;

  *Variable: DaysFromV1;
  DaysFromV1 = VisitDate - V1date; *Should be zero since it is the first visit;
  label  DaysFromV1 = "Days from Visit 1";
  format DaysFromV1 5.0;

  *Variable: YearsFromV1;
  YearsFromV1 = (VisitDate - V1date)/365.25; *Should be zero since it is the first visit;
  label  YearsFromV1 = "Years from Visit 1";
  format YearsFromV1 5.0;

  *Variable: ARIC;
  if      substr(subjid, 2, 6) >  '50000' then ARIC = 0; *JHS-Only;
  else if substr(subjid, 2, 6) <= '50000' then ARIC = 1; *Shared ARIC;
  else if missing(subjid)                 then ARIC = .;
  label   ARIC = "Shared-ARIC / JHS-Only";
  format  ARIC aric.;

  *Variable: recruit;
  if      recruitType = 'A' then recruit = 1; *Shared ARIC;
  else if recruitType = 'H' then recruit = 2; *ARIC Household;
  else if recruitType = 'R' then recruit = 3; *Random;
  else if recruitType = 'F' then recruit = 4; *Family;
  else if recruitType = 'V' then recruit = 5; *Volunteer;
  else                           recruit = .;
  label recruit = "JHS Recruitment Type";
  format recruit recruit.;

  *Variable: ageIneligible;
    
    *Sub-Variable: baselineAge;
    baselineAge = ((VisitDate - DaysFromV1) - dob) / 365.25;

  ageIneligible = (baselineAge < 34.5 | baselineAge > 85.5) & missing(familyid) & recruit ^= 4 & ^missing(baselineAge);
  label ageIneligible = "Outside of Original Target Enrollment Age";
  format ageIneligible ynfmt.;

  *Variable: FastHours;
  FastHours = ((FHhr * 60) + FHmin) / 60;
  label  FastHours = "Fasting Time (in hours)";
  format FastHours 5.2;  *Output time in hours;
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

%put Section 01 Complete;
