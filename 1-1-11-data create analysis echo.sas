***************************************************************************;
********************** Section 11: Echocardiogram *************************;
***************************************************************************;

title "Section 11: Echocardiogram";

*ECHA;
data include1; *ECHA;
  set jhsV1.echa(keep = subjid echa23 echa41 echa43 echa44 echa45 echa49);
  by subjid;

  *Create renamed duplicates for formulas;
  EF             = echa23 * 1; *Convert to numeric variable;
  diastlvst      = echa41;
  DiastLVdia     = echa43;
  SystLVdia      = echa44;
  diastwt        = echa45;
  LVMecho        = echa49;
  run;

*ANTV;
data include2; *ANTV;
    set jhsV1.antv(keep = subjid antv1);
    by subjid;

    *Create renamed duplicates for formulas;
    height  = antv1;
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
  proc freq data = include; tables inc1*inc2 /missing; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

  *Create variables;
  data include; set include; *Create Variables;
    by subjid;

    *Variable: LVMecho;
    label LVMecho = "Left Ventricular Mass (g) from Echo";
    format LVMecho 8.2;

    *Variable: LVMindex;
    LVMindex = LVMecho/((height/100)**2.7);
    label LVMindex = "Left Ventricular Mass Indexed by Height^2.7";
    format LVMindex 8.2;

    *Variable: LVH;
    if LVMindex <= 51    then LVH = 0;
    if LVMindex >  51    then LVH = 1;
    if missing(LVMindex) then LVH = .;
    label LVH = "Left Ventricular Hypertrophy" ;
    format LVH pafmt.;

    *Variable: EF;
    label EF = "Ejection Fraction";
    format EF 3.0;

    *Variable: EF3cat;
    if 55 <  EF       then EF3cat = 0;
    if 40 <= EF <= 55 then EF3cat = 1;
    if       EF <  40 then EF3cat = 2;
    if missing(EF)    then EF3cat = .;

    label EF3cat = "Ejection Fraction Categorization";
    format EF3cat EF3cat.;

    *Variable: DiastLVdia;
    label DiastLVdia = "Diastolic LV Diameter (mm)";
    format DiastLVdia 8.2;

    *Variable: SystLVdia;
    label SystLVdia = "Systolic LV Diameter (mm)";
    format SystLVdia 8.2;

    *Variable: FS;
    if ((DiastLVdia - SystLVdia)/DiastLVdia) >= 0.29 then FS = 0;
    if ((DiastLVdia - SystLVdia)/DiastLVdia) <  0.29 then FS = 1;
    if missing(DiastLVdia) | missing(SystLVdia)      then FS = .;
    label FS = "Fractional Shortening";
    format FS abnormal.;

    *Variable: RWT;
    RWT = (diastlvst + diastwt)/DiastLVdia;
    label  RWT = "Relative Wall Thickness";
    format RWT 8.2;
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
%let keep11echo = LVMecho     LVMindex   LVH  EF   EF3cat  
                  DiastLVdia  SystLVdia  FS   RWT;

%put Section 11 Complete;
