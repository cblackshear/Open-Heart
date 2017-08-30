********************************************************************;
******************** Section 2: Demographics ***********************;
********************************************************************;

title "Section 2: Demographics";

*RHXA;
data include1; *RHXA;
  set jhsV1.rhxa(keep = subjid rhxa8);
  by subjid;

  *Create renamed duplicates for formulas;
  menopauseYN = rhxa8;
  run;

*ANALYSIS;
data include2; *ANALYSIS;
  set analysis(keep = subjid VisitDate);
  by subjid;
  run;

*ELGA;
data include3; *ELGA;
  set splmnt.elga(keep = subjid elga4 elga5a);
  by subjid;

  *Create renamed duplicates for formulas;
  gender = elga4;
  dob    = elga5a;
  format dob mmddyy10.;
  run;

*TOBA;
data include4; *TOBA;
  set jhsV1.toba(keep = subjid toba1 toba3);
  by subjid;

  *Create renamed duplicates for formulas;
  currentSmokerYN = toba3;
  everSmokerYN    = toba1;
  run;

*ADRA;
data include5; *ADRA;
  set jhsV1.adra(keep = subjid adra1 adra2a adra2b adra3);

  *Create renamed duplicates for formulas;
  drinking = adra1;
  amount   = adra2a;
  unit     = adra2b;
  drinks   = adra3;
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
  if missing(menopauseYN) then menopause = .;
  if menopauseYN = 'N'    then menopause = 0;
  if menopauseYN = 'Y'    then menopause = 1;
  label menopause = "Menopause Status";
  format menopause ynfmt.;

  *Variable: alc;
       if drinking = 'Y' then alc = 1;
  else if drinking = 'N' then alc = 0;
  else if drinking = 'S' then alc = 0;
  else if drinking = ' ' then do;
	  if amount = 0 then alc = 0;
	  if drinks = 0 then alc = 0;
    end;

  label  alc = "Alcohol drinking in the past 12 months (Y/N)";
  format alc ynfmt.;

  *Variable: drm;
  if alc = 1 then do;
  	if unit = 'W'                then drm = amount*4;
	  if unit = 'W' & amount > 7   then drm = .;
	  if unit = 'M'                then drm = amount;
	  if unit = 'M' & amount > 30  then drm = .;
	  if unit = 'Y'                then drm = amount/12;
	  if unit = 'Y' & amount > 365 then drm = .;
    end;
  if alc = 0 then drm = 0;

  label  drm = "Alcohol drinking in the past 12 months (days per month)";
  format drm 8.2;

  *Variable: drw;
  if alc = 1 then do;
	  if unit = 'W'                then drw = amount;
	  if unit = 'W' & amount > 7   then drw = .;
	  if unit = 'M'                then drw = amount/4;
	  if unit = 'M' & amount > 30  then drw = .;
	  if unit = 'Y'                then drw = amount/52;
	  if unit = 'Y' & amount > 365 then drw = .;
    end;
  if alc = 0 then drw = 0;

  label  drw = "Alcohol drinking in the past 12 months (days per week)";
  format drw 8.2;

  *Variable: alcw;
  if alc = 1 then do;
	       if drinks = 88 then alcw = .;
	  else if drinks = .  then alcw = .;
	  else                     alcw = drinks*drw;
    end;
  if alc = 0 then alcw=0;

  label  alcw = "Average number of drinks per week in the past 12 months";
  format alcw 8.2;

  /*
  *Variable: alcd;
  if alc = 1 then do;
	  alcd = alcw/7;
    end;
  if alc = 0 then alcd = 0;

  label  alcd = "Average number of drinks per day in the past 12 months";
  format alcd 8.2;
  */

  *Variable: currentSmoker;
  if missing(currentSmokerYN) then currentSmoker = .;
  if everSmokerYN    = 'N'    then currentSmoker = 0;
  if currentSmokerYN = 'N'    then currentSmoker = 0;
  if currentSmokerYN = 'Y'    then currentSmoker = 1;

  label  currentSmoker = "Indication of participant's current cigarette smoking status";
  format currentSmoker ynfmt.;

  *Variable: everSmoker;
  if everSmokerYN = 'N'    then everSmokerV1 = 0;
  if everSmokerYN = 'Y'    then everSmokerV1 = 1; 
  if missing(everSmokerYN) then everSmokerV1 = .; 

  everSmokerV3 = .;

  everSmoker = 0;
  if everSmokerV1          | everSmokerV3          then everSmoker = 1;
  if missing(everSmokerV1) & missing(everSmokerV3) then everSmoker = .;

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

*Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep02demogs = age brthyr brthmo sex male menopause alc /*drm drw*/ alcw /*alcd*/ currentSmoker everSmoker; 

%put Section 02 Complete;
