********************************************************************;
******************* Section 5: Hypertension ************************;
********************************************************************;

title "Section 5: Hypertension";

*SBPA;
data include1; *SBPA;
  set jhsV1.sbpa(keep = subjid sbpa13 sbpa14 sbpa15 sbpa16 sbpa17 sbpa18 sbpa19 sbpa20); 
  by subjid;

  *Create renamed duplicates for formulas;
  sbp = sbpa19;
  dbp = sbpa20;

    *Create these for validation purposes;
    sbpMeas1  = sbpa13;
    dbpMeas1  = sbpa14;
    zeroRead1 = sbpa15;
    sbpMeas2  = sbpa16;
    DBPmeas2  = sbpa17;
    zeroRead2 = sbpa18;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid BPmedsSelf);
  by subjid;
  run;

* ABBA;
data include3; *ABBA;
  set jhsV1.abba;
  by subjid;

  *Use highest ankle/posterior tibial as numerator;
	abi_num = max(abba9, abba10, abba8, abba11);	

  *Use highest brachial pressure as denominator;
 	abi_den = max(abba7, abba12) ;

  keep subjid abi_num abi_den;
  run;


*Combine datasets and merge checking variables;
data include; *Combine datasets and merge checking variables;
  merge include1(in = in1)
        include2(in = in2)
	      include3(in = in3);
  by subjid; 
    inc1 = in1; 
    inc2 = in2;
  	inc3 = in3;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1*inc2 /missing; run;
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include; 
    drop inc1 inc2 inc3 chkobs; 
    run;

*Create Variables;
data include; *Create Variables;
  set include; 

  *Variable: SBP;
  sbp = sbp + 11.0512 - (0.0831*sbp);
  label  sbp = "Systolic Blood Pressure (mmHg)";
  format sbp 8.2;

  *Variable: DBP;
  dbp = dbp + 10.2999 - (0.1699*dbp);
  label  dbp = "Diastolic Blood Pressure (mmHg)";
  format dbp 8.2;

  *Variable: BPjnc7;

    *Subvariable: sbpHTN;
    if sbp <  120               then sbpHTN = 0; *0 = Ideal;
    if sbp >= 120 and sbp < 140 then sbpHTN = 1; *1 = pre;
    if sbp >= 140 and sbp < 160 then sbpHTN = 2; *2 = Stage I;
    if sbp >= 160               then sbpHTN = 3; *3 = Stage II;
    if missing(sbp) then sbpHTN = .;
    format sbpHTN BPcat.;

    *Subvariable: dbpHTN;
    if dbp <  80               then dbpHTN = 0; *0 = Ideal;
    if dbp >= 80 and dbp < 90  then dbpHTN = 1; *1 = pre;
    if dbp >= 90 and dbp < 100 then dbpHTN = 2; *2 = Stage I;
    if dbp >= 100              then dbpHTN = 3; *3 = Stage II;
    if missing(dbp) then dbpHTN = .; 
    format dbpHTN BPcat.;

  BPjnc7 = 3;
  if sbpHTN <= 2 & dbpHTN <= 2 then BPjnc7 = 2;
  if sbpHTN <= 1 & dbpHTN <= 1 then BPjnc7 = 1;
  if sbpHTN  = 0 & dbpHTN  = 0 then BPjnc7 = 0;
  if missing(sbpHTN) or missing(dbpHTN) then BPjnc7 = .; *Note: if missing one, then missing both;
  label  BPjnc7 = "JNC 7 BP Classification";
  format BPjnc7 BPcat.;

  *Variable: HTN;
  if (BPjnc7 <= 1) & (BPmedsSelf = 0 | missing(BPmedsSelf)) then HTN = 0;
  if  BPjnc7 >= 2 | BPmedsSelf = 1                          then HTN = 1;
  if  missing(BPjnc7) & missing(BPmedsSelf)                 then HTN = .;
  label  HTN = "Hypertension Status";
  format HTN ynfmt.;

  *Variable: ABI;
  if (abi_num = .) | (abi_den = .) then abi = .;
    else abi = (abi_num / abi_den);
	label  abi = "Ankle Brachial Index";
  format abi 8.2;
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
%let keep05htn = sbp dbp BPjnc7 HTN abi; 

%put Section 05 Complete;
