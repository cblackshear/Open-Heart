********************************************************************;
******************* Section 5: Hypertension ************************;
********************************************************************;

title "Section 5: Hypertension";

*SBPC;
data include1; *SBPC;
  set jhsV3.sbpc(keep = subjid sbpc19 sbpc20); 
  by subjid;

  *Create renamed duplicates for formulas;
  sbp = sbpc19;
  dbp = sbpc20;
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid BPmedsSelf);
  by subjid;
  run; 

* ABBB;
data include3; *ABBB;
  set jhsV3.abbb;
  by subjid;

  * Use highest ankle/posterior tibial as numerator;
	abi_num = max(abbb9, abbb10, abbb8, abbb11);	

  * Use highest brachial pressure as denominator;
 	abi_den = max(abbb7, abbb12) ;

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
  proc freq data=include; tables inc1*inc2; run;
  proc print data=include(where=(chkobs>1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 inc3 chkobs;
    run;

*Create Variables;
data include; *Create Variables;
  set include; 

  *Variable: sbp;
  label  sbp = "Systolic Blood Pressure (mmHg)";
  format sbp 8.2;

  *Variable: dbp;
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
  if missing(sbpHTN) | missing(dbpHTN) then BPjnc7 = .; *Note: if missing one, then missing both;
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

%put Section 05 Complete;
