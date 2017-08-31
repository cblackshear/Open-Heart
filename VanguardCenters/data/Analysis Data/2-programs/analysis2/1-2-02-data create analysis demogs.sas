********************************************************************;
******************** Section 2: Demographics ***********************;
********************************************************************;

title "Section 2: Demographics";

*ANALYSIS;
data include2; *ANALYSIS;
  set analysis(keep = subjid VisitDate);
  by subjid;
  run;

*ELGA;
data include1; *ELGA;
  set splmnt.elga(keep = subjid elga4 elga5a);
  by subjid;

  *Create renamed duplicates for formulas;
  gender = elga4;
  dob    = elga5a;
  format dob mmddyy10.;
  run;

*Combine datasets and merge checking variables;
data include; *Combine datasets and merge checking variables;
  merge include1(in = in1)
        include2(in = in2);
  by subjid; 
    inc1 = in1;
    inc2 = in2; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data=include; tables inc1*inc2; run;
  proc print data=include(where=(chkobs>1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: age;
  age = (VisitDate - dob) / 365.25;
  label  age = "Age in Years";
  format age 5.1;

  *Variable: brthyr;
  brthyr = year(dob);
  label  brthyr = "Year of Birth";
  format brthyr 4.0;

  *Variable: brthmo;
  brthmo = month(dob);
  label  brthmo = "Month of Birth";
  format brthmo 2.0;

  *Variable: sex;
  if      gender = 'F' then sex = 'Female';
  else if gender = 'M' then sex = 'Male';
  label   sex = "Participant Sex";
  format  sex $7.;

  *Variable: male;
  if      gender = 'F' then male = 0;
  else if gender = 'M' then male = 1;
  label   male = "Male Indicator";
  format  male male.;

  *Variable: menopause;
  menopause = .; *Not collected in Visit 2;
  label menopause = "Menopause Status";
  format menopause ynfmt.;

  *Variable: alc;
  alc = .; *Not Collected in Visit 2;

  label  alc = "Alcohol drinking in the past 12 months (Y/N)";
  format alc ynfmt.;

  *Variable: drm;
  drm = .; *Not Collected in Visit 2;

  label  drm = "Alcohol drinking in the past 12 months (days per month)";
  format drm 8.2;

  *Variable: drw;
  drw = .; *Not Collected in Visit 2;

  label  drw = "Alcohol drinking in the past 12 months (days per week)";
  format drw 8.2;

  *Variable: alcw;
  alcw = .; *Not Collected in Visit 2;

  label  alcw = "Average number of drinks per week";
  format alcw 8.2;

  /*
  *Variable: alcd;
  alcd = .; *Not Collected in Visit 2;
  */

  label  alcd = "Average number of drinks per day";
  format alcd 8.2;

  *Variable: currentSmoker;
  currentSmoker = .; *Not Collected in Visit 2;

  label  currentSmoker = "Indication of participant's current cigarette smoking status";
  format currentSmoker ynfmt.;

  *Variable: everSmoker;
  everSmoker = .; *Not Collected in Visit 2;

  label  everSmoker = "Indication of whether the participant has ever smoked cigarettes ";
  format everSmoker ynfmt.;
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

%put Section 02 Complete;
