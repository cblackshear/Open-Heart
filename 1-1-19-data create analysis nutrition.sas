*******************************************************************;
*******************   Section 19: Nutrition     *******************;
*******************************************************************;

title "Section 19: Nutrition ";

*CENA;
data include1; *CENA;
  set jhsv1.cena(keep = subjid vitaminD3 vitaminD2 vitaminD3epimer);
  by subjid;
  run;

*Nutrition variables ;
data include2; *DFGA;
  set ssn0006.jhs_ndsr_fdgrps(keep = subjid fgscfVEG0100_Sum fgscfMOF0300_Sum fgscfMFF0100_Sum);
  by subjid;

  *Create renamed duplicates for formulas;
  darkgrnVeg = fgscfVEG0100_Sum;
  eggs       = fgscfMOF0300_Sum;
  fish       = fgscfMFF0100_Sum;
  run;

*Combine Datasets Sequentially ***************************************************;

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

*Format and label variables ***************************************************;
data include; *Create variables; 
  set include; 
  by subjid; 
  
  *Variable: vitaminD2;
  label  vitaminD2 = "25(OH) Vitamin D2 (ng/mL)";
  format vitaminD2 8.2;

  *Variable: vitaminD3;
  label  vitaminD3 = "25(OH) Vitamin D3 (ng/mL)";
  format vitaminD3 8.2;

  *Variable: vitaminD3epimer;
  label  vitaminD3epimer = "ep-25(OH) Vitamin D3 (ng/mL)";
  format vitaminD3epimer 8.2;

  *Variable: darkgrnVeg;
  label  darkgrnVeg = "Dark-green Vegetables";
  format darkgrnVeg 8.2;

  *Variable: eggs;
  label  eggs = "Eggs";
  format eggs 8.2;

  *Variable: fish;
  label  fish = "Fish" ;
  format fish 8.2;
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
%let keep19bnutri = vitaminD2 vitaminD3 vitaminD3epimer darkgrnVeg eggs fish;             

%put Section 19 Complete;
