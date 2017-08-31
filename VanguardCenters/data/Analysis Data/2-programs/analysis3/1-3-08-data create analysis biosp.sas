********************************************************************;
******************** Section 8: Biospecimens ***********************;
********************************************************************;

title "Section 8: Biospecimens";

*CENC;
data include1; *CENC;
  set jhsV3.cenc(keep = subjid crphs2 eSelectin pSelectin);
  by subjid;

  *Create renamed duplicates for formulas;
  hsCRP = (crphs2 / 10);
  run;

data include2; *

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
  label eSelectin = "e-Selectin";
  format eSelectin 6.2;

  *Variable: pSelectin;
  label pSelectin = "p-Selectin";
  format pSelectin 6.2;

  *Variable: endothelin;
  endothelin = .; *Not collected in Visit 3;
  label endothelin = "Concentration of Endothelin-1 (pg/mL)";
  format endothelin 6.2;

  *Variable: sCort;
  sCort = .; *Not collected in Visit 3;
  label sCort = "Concentration of Cortisol Levels (ug/dL)";
  format sCort 6.2;

  *Variable: reninRIA;
  reninRIA = .; *Not collected in Visit 3;
  label reninRIA = "Renin Activity RIA (Plasma ng/mL/hr)";
  format reninRIA 6.2;

  *Variable: reninIRMA;
  reninIRMA = .; *Not collected in Visit 3;
  label reninIRMA = "Renin Mass IRMA (pg/mL)";
  format reninIRMA 6.2;
  
  *Variable: aldosterone;
  aldosterone = .; *Not collected in Visit 3;
  label aldosterone = "Concentration of Aldosterone (ng/dL)";
  format aldosterone 6.2;

  *Variable: leptin;
  leptin = .; *Not collected in Visit 3;

  *Variable: adiponectin;
  adiponectin = .; *Not collected in Visit 3;
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
