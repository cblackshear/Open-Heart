********************************************************************;
******************* Section 5: Hypertension ************************;
********************************************************************;

title "Section 5: Hypertension";

*SBPB;
data include1; *SBPB;
  set jhsV2.sbpb(keep = subjid sbpb16 sbpb17 sbpb18 sbpb19 
                               sbpb20 sbpb21 sbpb22 sbpb23
              							   sbpb25 sbpb26 sbpb27 sbpb28
              							   sbpb29 sbpb30); 
  by subjid;

  *Create calibration indicator;
  if ^missing(sbpb29) & ^missing(sbpb30) then calibrate = 0; * don't calibrate those with AOD;
  if ^missing(sbpb22) & ^missing(sbpb23) & missing(sbpb29) & missing(sbpb30) then calibrate = 1; * calibrate those with RZS only;

  *Create renamed duplicates for formulas;
  if calibrate=1 then do; * keep RZS;                    
  	sbp = sbpb22;
  	dbp = sbpb23;
	end;

  if calibrate=0 then do; * keep AOD;
  	sbp = sbpb29;
  	dbp = sbpb30;
	end;

    *Create these for validation purposes;
    Meas1  = sbpb16;
    dbpMeas1  = sbpb17;
    zeroRead1 = sbpb18;
    sbpMeas2  = sbpb19;
    dbpMeas2  = sbpb20;
    zeroRead2 = sbpb21;
	
  run;

*analysis;
data include2; *analysis;
  set analysis(keep = subjid BPmedsSelf);
  by subjid;
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
  proc freq data=include; tables inc1*inc2; run;
  proc print data=include(where=(chkobs>1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Create Variables;
data include; *Create Variables;
  set include; 

  *Variable: sbp;
  if calibrate = 1 then do;
  	sbp = sbp + 11.0512 - (0.0831*sbp);
	  end;
  label  sbp = "Systolic Blood Pressure (mmHg)";
  format sbp 8.2;

  *Variable: dbp;
  if calibrate = 1 then do;
	  dbp = dbp + 10.2999 - (0.1699*dbp);
	  end;
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
  abi = .; *Not collected in Visit 2;
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
