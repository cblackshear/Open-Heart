********************************************************************;
******************** Section 8: Biospecimens ***********************;
********************************************************************;

title "Section 8: Biospecimens";

*CENA;
data include1; *CENA;
  set jhsV1.cena(keep = subjid hscrp endothelin cortisol renin renin2 aldosterone leptin cystatinC);
  by subjid;

  *Create renamed duplicates for formulas;
  eSelectin = .; *Not collected in Visit 1;
  pSelectin = .; *Not collected in Visit 1;
  sCort     = cortisol;
  reninRIA  = renin;
  reninIRMA = renin2;
  run;

*ASN0041;
data include2; *ASN0041;
	set asn0041.asn0041 (keep = subjid adiponectin);
	by subjid;
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

*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: hsCRP;
  label hsCRP = "High Sensitivity C-Reactive Protein (Plasma mg/dL)";
  format hsCRP 6.3;

  *Variable: eSelectin;
  label eSelectin = "e-Selectin (Plasma ng/mL)";
  format eSelectin 6.2;

  *Variable: pSelectin;
  label pSelectin = "p-Selectin (Plasma ng/mL)";
  format pSelectin 6.2;

  *Variable: endothelin;
  label endothelin = "Endothelin-1 (Plasma pg/mL)";
  format endothelin 6.2;

  *Variable: sCort;
  label sCort = "Concentration of Cortisol Levels (Plasma ug/dL)";
  format sCort 6.2;

  *Variable: reninRIA;
  label reninRIA = "Renin Activity RIA (Plasma ng/mL/hr)";
  format reninRIA 6.2;

  *Variable: reninIRMA;
  label reninIRMA = "Renin Mass IRMA (pg/mL)";
  format reninIRMA 6.2;
  
  *Variable: aldosterone;
  label aldosterone = "Concentration of Aldosterone (Plasma ng/dL)";
  format aldosterone 6.2;

  *Variable: leptin;
  label leptin = "Concentration of Leptin (Plasma ng/mL)";
  format leptin 6.2;

  *Variable: cystatinC;
  label cystatinC = "Concentration of Cystatin C (Serum mg/L)"
  format cystatinC 6.2;
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
%let keep08biosp = hsCRP 	   eSelectin  pSelectin    endothelin  sCort 	
                   reninRIA  reninIRMA  aldosterone  leptin      adiponectin;

%put Section 08 Complete;
