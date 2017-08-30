********************************************************************;
*********************** Section 21: Genetics ***********************;
********************************************************************;

title "Section 21: Genetics";

*Sickle Cell;
data include1; *Sickle Cell;
  set asn0069.sickle_cell_trait_dat;
  by subjid;
  run;

*Apol;
data include2;
  set asn0069.apol1;
  by subjid;
  run;

*1000Genome;
data include3;
  set asn0033.SNP1KGenome;
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


*Create variables;
data include; *Create variables; 
  set include; 
  by subjid;

  *Variable: Sickle cell trait / Disease;
  SickleCelldis = .;
  label  Sicklecelldis = "Sickle Cell trait / disease (rs334)";
  *format Sicklecelldis rs334fm.;
   
  *Variable: SickleCell;
       if sct in (1, 2) then SickleCell = 1;
  else if sct in (0)    then SickleCell = 0;
  label  SickleCell = "Sickle Cell (rs334)";
  format SickleCell sicklecellfm.;

  *Variable: APOL1G1;
       If rs73885319 = "0/0" and rs60910145 =   "0/0"         then APOL1G1 = 0;   *(there are 1919 participants);
  else If rs73885319 = "0/1" and rs60910145 in ("0/0", "0/1") then APOL1G1 = 1;   *(there are 28+1096=1124 participants);
  else If rs73885319 = "1/1" and rs60910145 =   "1/1"         then APOL1G1 = 2;   *(there are 170 participants);
  else If rs73885319 = "1/1" and rs60910145 =   "0/1"         then APOL1G1 = 1.1; *(11 participants which is the group you called G1a);

  label  APOL1G1 = "'APOL1 G1 Risk Allele from SNPs rs73885319 and rs60910145";
  format APOL1G1 APOL1G1fm.;

  *Variable: APOL1G2;
       if rs71785313 = "0/0" then APOL1G2 = 0;
  else if rs71785313 = "0/1" then APOL1G2 = 1;
  else if rs71785313 = "1/1" then APOL1G2 = 2;
  label  APOL1G2 = "APOL1 G2 risk allele from indel rs71785313";
  format APOL1G2 APOL1G2fm.;

  *Variable: APOL1risk;
      if   (APOL1G1  = 0 & APOL1G2 = 0)                                                                                                then APOL1risk = 0; *N=1295;
  else if ((APOL1G1  = 1 & APOL1G2 = 0) | (APOL1G1 = 0 & APOL1G2 = 1) | (APOL1G1 = 1.1 & APOL1G2 = 0))                                 then APOL1risk = 1; *N=911+571+11;
  else if ((APOL1G1  = 2 & APOL1G2 = 0) | (APOL1G1 = 0 & APOL1G2 = 2) | (APOL1G1 = 1   & APOL1G2 = 1) | (APOL1G1 = 1.1 & APOL1G2 = 1)) then APOL1risk = 2; *N=170+50;
  label  APOL1risk = "APOL1 CVD risk genotype";
  format APOL1risk apol1riskfm.;

  *Variable: Duffy;
  Duffy = rs2814778;
  *rs2814778_rd = round(rs2814778, 1);
  label  Duffy = "Duffy blood group antigen (rs2814778)";
  format Duffy rs2814778fm.;

  *Variable: PCSK9;
  PCSK9 = rs28362286;
  *rs28362286_rd = round(rs28362286, 1);
  label  PCSK9 = "PCSK9-C679X Low density lipoprotein cholesterol level quantitative trait locus 1 (rs28362286)"; 
  format PCSK9 rs28362286fm.;

  /*Variable: G6PD; 
  G6PD = rs1050828;
  *rs1050828_rd = round(rs1050828, 1);
  label  G6PD = "glucose-6-phosphate dehydrogenase(rs1050828) ";
  format G6PD rs1050828fm.;
  */

  *Variable: SCN5A_S1103Y;
  SCN5A_S1103Y = rs7626962;
  *rs7626962_rd = round(rs7626962, 1);
  label  SCN5A_S1103Y = "SerineTyrosine Substitution at AA1103 (rs7626962)";
  format SCN5A_S1103Y rs7626962fm.;
   
  *Variable: HbC;
  HbC = rs33930165;
  *rs33930165_rd = round(rs33930165, 1);
  label  HbC = "Hemoglobin C (HbC) locus (rs33930165)";
  format HbC rs33930165fm.;
  run;
 
*Add to Analysis Dataset;
data analysis; *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
  if in1 = 1; *Only keep clean ptcpts;
  run;

  *Create keep macro variable for variables to retain in Analysis dataset (vs. analysis);
%let keep21genetics = SickleCelldis SickleCell APOL1G1 APOL1G2 APOL1risk Duffy PCSK9 SCN5A_S1103Y HbC;

%put Section 21 Complete;
