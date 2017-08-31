********************************************************************;
******************** Section 8: Biospecimens ***********************;
********************************************************************;

title "Section 8: Biospecimens";

*CENB;
data include1; *CENB;
  set jhsV2.cenb(keep = subjid crphs2);
  by subjid;

  *Create renamed duplicates for formulas;
  hsCRP = (crphs2 / 10);
  run;

*Combine datasets and merge checking variables;
data include; *Combine datasets and merge checking variables;
  merge include1(in = in1);
  by subjid; 
    inc1 = in1; 
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
    proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include; 
    drop inc1 chkobs; 
    run;

*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: hsCRP;
  label hsCRP = "High Sensitivity C-Reactive Protein (mg/dL)";
  format hsCRP 6.3;

  *Variable: eSelectin;
  eSelectin = .; *Not collected in Visit 2;
  label eSelectin = "e-Selectin";
  format eSelectin 6.2;

  *Variable: pSelectin;
  pSelectin = .; *Not collected in Visit 2;
  label pSelectin = "p-Selectin";
  format pSelectin 6.2;

  *Variable: endothelin;
  endothelin = .; *Not collected in Visit 2;
  label endothelin = "Concentration of Endothelin-1 (pg/mL)";
  format endothelin 6.2;

  *Variable: sCort;
  sCort = .; *Not collected in Visit 2;
  label sCort = "Concentration of Cortisol Levels (ug/dL)";
  format sCort 6.2;

  *Variable: reninRIA;
  reninRIA = .; *Not collected in Visit 2;
  label reninRIA = "Renin Activity RIA (Plasma ng/mL/hr)";
  format reninRIA 6.2;

  *Variable: reninIRMA;
  reninIRMA = .; *Not collected in Visit 2;
  label reninIRMA = "Renin Mass IRMA (pg/mL)";
  format reninIRMA 6.2;
  
  *Variable: aldosterone;
  aldosterone = .; *Not collected in Visit 2;
  label aldosterone = "Concentration of Aldosterone (ng/dL)";
  format aldosterone 6.2;

  *Variable: leptin;
  leptin = .; *Not collected in Visit 2;

  *Variable: adiponectin;
  adiponectin = .; *Not collected in Visit 2;
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

%put Section 08 Complete;
