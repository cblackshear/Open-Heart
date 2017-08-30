*MEDCODES;
data include1; *MEDCODES;
  set jhsv1.medcodes(keep = subjid tccode);
  by subjid;

  tccode2 = (substr(tccode, 1, 2) + 0); *First two digits;
  tccode3 = (substr(tccode, 1, 3) + 0); *First three digits;
  tccode4 = (substr(tccode, 1, 4) + 0); *First four digits;
  tccode6 = (substr(tccode, 1, 6) + 0); *First six digits;

  if (33 <= tccode2 <= 37)           then BPmeds      = 1; else BPmeds          = .; *BP meds indicator;
  if (tccode2 = 27 & tccode3 ^= 271) then DMmedsOral  = 1; else DMmedsOral      = .; *Diabetic oral meds indicator;
  if (tccode3 = 271)                 then DMmedsIns   = 1; else DMmedsIns       = .; *Diabetic insulin meds indicator;
  if (tccode2 = 27)                  then DMmeds      = 1; else DMmeds          = .; *Diabetic meds indicator;
  if (tccode4 = 3940)                then statinMeds  = 1; else statinMeds      = .; *Statin meds indicator;
  if (24 <= tccode2 <= 26)           then hrtMeds     = 1; else hrtMeds         = .; *Hormone replacement therapy meds indicator;
  if (tccode2 = 33) * 1              then betaBlkMeds = 1; else betaBlkMeds     = .; *Beta blocker meds indicator;
  if (tccode2 = 34     | 
      tccode6 = 369915 | 
      tccode6 = 369925)              then calBlkMeds   = 1; else calBlkMeds     = .; *Calcium channel blocker meds indicator;
  if (tccode2 = 37     | 
      tccode6 = 369918 |
      tccode6 = 369920 |
      tccode6 = 369940 |
      tccode6 = 369950 |
      tccode6 = 369955 |
      tccode6 = 369970 |
      tccode6 = 369980 |
      tccode6 = 369990)              then diureticMeds  = 1; else diureticMeds  = .; *Diuretic meds indicator;
  if (tccode2 = 35)                  then antiArythMeds = 1; else antiArythMeds = .; *Anti-Arrhythmic meds indicator;

  *Remove individual meds per Harman HTN paper;
  if BPmeds = 1 then do;
    if   tccode2 =  35          then BPmeds = 0; *Delete Antiarrhythmics;
    if   tccode3 =  363         then BPmeds = 0; *Delete pheochromocytoma agents;
    if   tccode  = "3640002000" then BPmeds = 0; *Delete minoxidil;
    if   tccode3 =  371         then BPmeds = 0; *Delete carbonic anhydrase inhibitors;
    if   tccode  = "3799200410" then BPmeds = 0; *Delete herbal;
    end;
  run;
  *proc print data = include2(obs = 30); run;
    *Obtain single row per ptcpt of # of BPmeds;
    proc means data = include1 noprint; *Obtain single row per ptcpt of # of meds;
      class subjid;
      var BPmeds DMmedsOral DMmedsIns DMmeds statinMeds hrtMeds betaBlkMeds calBlkMeds diureticMeds antiArythMeds;
      ways 1;
      output out = include1(drop = _TYPE_  _FREQ_) 
             sum = numBPmeds numDMmedsOral numDMmedsIns numDMmeds numstatinMeds numhrtMeds numbetaBlkMeds numcalBlkMeds numdiureticMeds numantiArythMeds;
      run;
      *proc print data = include1(obs = 30); run;
    data include1; *Obtain single row per ptcpt of 0/1 = No/Yes, on a med;
      set include1;
      if NOT missing(numBPmeds)         then BPmeds         = numBPmeds         > 0;
      if NOT missing(numDMmedsOral)     then DMmedsOral     = numDMmedsOral     > 0;
      if NOT missing(numDMmedsIns)      then DMmedsIns      = numDMmedsIns      > 0;
      if NOT missing(numDMmeds)         then DMmeds         = numDMmeds         > 0;
      if NOT missing(numstatinMeds)     then statinMeds     = numstatinMeds     > 0;
      if NOT missing(numhrtMeds)        then hrtMeds        = numhrtMeds        > 0;
      if NOT missing(numbetaBlkMeds)    then betaBlkMeds    = numbetaBlkMeds    > 0;
      if NOT missing(numcalBlkMeds)     then calBlkMeds     = numcalBlkMeds     > 0;
      if NOT missing(numdiureticMeds)   then diureticMeds   = numdiureticMeds   > 0;
      if NOT missing(numantiArythMeds)  then antiArythMeds  = numantiArythMeds  > 0;
      run;

*MSRA;
data include2; *MSRA;
  set jhsV1.msra(keep = subjid msra1 msra2 msra30a msra30b msra30c msra30d msra30e msra30f msra30g msra30h msra30i); 
  by subjid;

  *Create renamed duplicates for formulas;
  BPmedsSelfRep           = msra30a;
  statinMedsSelfRep       = msra30b;
  *anginaMedsSelfRep       = msra30c;
  antiArythMedsSelfRep    = msra30d;
  *HFmedsSelfRep           = msra30e;
  *bloodThinnerMedsSelfRep = msra30f;
  dmMedsSelfRep           = msra30g;
  *strokeMedsSelfRep       = msra30h;
  *legPainMedsSelfRep      = msra30i;

  broughtMeds = "NotAllMeds";
    if msra1 = "Y"    then broughtMeds = "AllMeds";
    if missing(msra1) then broughtMeds = "";

  whyNOmeds = "Other    ";
    if msra2 = "T"    then whyNOmeds = "NoneTaken";
    if missing(msra2) then whyNOmeds = "";
  run;

*RHXA;
data include3; *RHXA;
  set jhsV1.rhxa(keep = subjid rhxa17 rhxa20); 
  by subjid;

  *Create renamed duplicates for formulas;
  hrtMedsEver    = rhxa17; 
  hrtMedsCurrent = rhxa20;
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

*Create Variables;
data include; *Create Variables;
  set include;

  *Variable: medAcct;
  medAcct = 0;
  if whyNOmeds   = "NoneTaken"                 then medAcct = 1;
  if broughtMeds = "AllMeds"                   then medAcct = 2;
  if missing(broughtMeds) & missing(whyNOmeds) then medAcct = .;
  label medAcct = "Medication Accountability";
  format medAcct medAcct.;
 
  *Variable: BPmedsSelf;
  BPmedsSelf = .;
  if BPmedsSelfRep = "N"          then BPmedsSelf = 0;
  if BPmedsSelf = . & medAcct = 1 then BPmedsSelf = 0;
  if BPmedsSelfRep = "Y"          then BPmedsSelf = 1;
  label   BPmedsSelf = "Self-Reported BP Medication Status (Y/N)";
  format  BPmedsSelf ynfmt.;

  *Variable: BPmeds;
  if medAcct = 1                      then BPmeds = 0;
  if medAcct = 2 & missing(BPmeds)    then BPmeds = 0; 
  if missing(BPmeds) & BPmedsSelf = 0 then BPmeds = 0;
  if BPmedsSelf = 1                   then BPmeds = 1;
  label  BPmeds = "Blood Pressure Medication Status (Y/N)";
  format BPmeds ynfmt.;

  *Variable: DMmedsOral;
  if medAcct = 1                       then DMmedsOral = 0;
  if medAcct = 2 & missing(DMmedsOral) then DMmedsOral = 0; 
  label  DMmedsOral = "Diabetic Oral Medication Status (Y/N)";
  format DMmedsOral ynfmt.;

  *Variable: DMmedsIns;
  if medAcct = 1                      then DMmedsIns = 0;
  if medAcct = 2 & missing(DMmedsIns) then DMmedsIns = 0; 
  label  DMmedsIns = "Diabetic Insulin Medication Status (Y/N)";
  format DMmedsIns ynfmt.;

  *Variable: DMMedType;
  if (DMmedsOral = 0 & DMmedsIns = 0) then DMMedType = 0; else
  if (DMmedsOral = 1 & DMmedsIns = 0) then DMMedType = 1; else
  if (DMmedsOral = 0 & DMmedsIns = 1) then DMMedType = 2; else
  if (DMmedsOral = 1 & DMmedsIns = 1) then DMMedType = 3; 
  label  DMMedType= "Type of Diabetic Medication";
  format DMMedType DMMedType.;

  *Variable: dmMedsSelf;
  dmMedsSelf = .;
  if dmMedsSelfRep = "N"          then dmMedsSelf = 0;
  if dmMedsSelf = . & medAcct = 1 then dmMedsSelf = 0;
  if dmMedsSelfRep = "Y"          then dmMedsSelf = 1;
  label  dmMedsSelf = "Self-Reported Diabetic Medication Status (Y/N)";
  format dmMedsSelf ynfmt.;

  *Variable: DMmeds;
  if medAcct = 1                      then DMmeds = 0;
  if medAcct = 2 & missing(DMmeds)    then DMmeds = 0; 
  if missing(DMmeds) & dmMedsSelf = 0 then DMmeds = 0;
  if dmMedsSelf = 1                   then DMmeds = 1;
  label  DMmeds = "Diabetic Medication Status (Y/N)";
  format DMmeds ynfmt.;

  *Variable: statinMedsSelf;
  statinMedsSelf = .;
  if statinMedsSelfRep = "N"          then statinMedsSelf = 0;
  if statinMedsSelf = . & medAcct = 1 then statinMedsSelf = 0;
  if statinMedsSelfRep = "Y"          then statinMedsSelf = 1;
  label  statinMedsSelf = "Self-Reported Statin Medication Status (Y/N)";
  format statinMedsSelf ynfmt.;

  *Variable: statinMeds;
  if medAcct = 1                              then statinMeds = 0;
  if medAcct = 2 & missing(statinMeds)        then statinMeds = 0; 
  if missing(statinMeds) & statinMedsSelf = 0 then statinMeds = 0;
  if statinMedsSelf = 1                       then statinMeds = 1;
  label  statinMeds = "Statin Medication Status (Y/N)";
  format statinMeds ynfmt.;

  *Variable: hrtMedsSelfEver;
  hrtMedsSelfEver = 0;
  if hrtMedsEver = "Y"    then hrtMedsSelfEver = 1;
  if missing(hrtMedsEver) then hrtMedsSelfEver = .;
  label hrtMedsSelfEver = "Self Reported HRT Medication Status (Y/N)";
  format hrtMedsSelfEver ynfmt.;

  *Variable: hrtMedsSelf;
  hrtMedsSelf = 0;
  if hrtMedsCurrent = "Y"    then hrtMedsSelf = 1;
  if missing(hrtMedsCurrent) then hrtMedsSelf = .;
  label hrtMedsSelf = "Self Reported Current HRT Medication Status (Y/N)";
  format hrtMedsSelf ynfmt.;

  *Variable: hrtMeds;
  if medAcct = 1                        then hrtMeds = 0;
  if medAcct = 2 & missing(hrtMeds)     then hrtMeds = 0; 
  if missing(hrtMeds) & hrtMedsSelf = 0 then hrtMeds = 0;
  if hrtMedsSelf = 1                    then hrtMeds = 1;
  label  hrtMeds = "Hormone Replacement Therapy Medication Status (Y/N)";
  format hrtMeds ynfmt.;

  *Variable: betaBlkMeds;
  if medAcct = 1                        then betaBlkMeds = 0;
  if medAcct = 2 & missing(betaBlkMeds) then betaBlkMeds = 0; 
  label  betaBlkMeds = "Beta Blocker Medication Status (Y/N)";
  format betaBlkMeds ynfmt.;

  *Variable: calBlkMeds;
  if medAcct = 1                       then calBlkMeds = 0;
  if medAcct = 2 & missing(calBlkMeds) then calBlkMeds = 0; 
  label  calBlkMeds = "Calcium Channel Blocker Medication Status (Y/N)";
  format calBlkMeds ynfmt.;

  *Variable: diureticMeds;
  if medAcct = 1                         then diureticMeds = 0;
  if medAcct = 2 & missing(diureticMeds) then diureticMeds = 0; 
  label  diureticMeds = "Diuretic Medication Status (Y/N)";
  format diureticMeds ynfmt.;

  *Variable: antiArythMedsSelf;
  antiArythMedsSelf = .;
  if antiArythMedsSelfRep = "N"          then antiArythMedsSelf = 0;
  if antiArythMedsSelf = . & medAcct = 1 then antiArythMedsSelf = 0;
  if antiArythMedsSelfRep = "Y"          then antiArythMedsSelf = 1;
  label  antiArythMedsSelf = "Self-Reported Antiarrhythmic Medication Status (Y/N)";
  format antiArythMedsSelf ynfmt.;

  *Variable: antiArythMeds;
  if medAcct = 1                                    then antiArythMeds = 0;
  if medAcct = 2 & missing(antiArythMeds)           then antiArythMeds = 0; 
  if missing(antiArythMeds) & antiArythMedsSelf = 0 then antiArythMeds = 0;
  if antiArythMedsSelf = 1                          then antiArythMeds = 1;
  label  antiArythMeds = "Antiarrhythmic Medication Status (Y/N)";
  format antiArythMeds ynfmt.;
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
%let keep04meds = medAcct      
                  BPmeds  BPmedsSelf  
                  DMmedsOral  DMmedsIns  DMMedType  dmMedsSelf  DMmeds      
                  statinMedsSelf  statinMeds  
                  hrtMedsSelf  hrtMeds  hrtMedsSelfEver 
                  betaBlkMeds  
                  calBlkMeds  
                  diureticMeds   
                  antiArythMedsSelf  antiArythMeds; 
