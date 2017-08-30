********************************************************************;
****************** Section 17: Psychosocial **********************;
********************************************************************;
title "Section 17: Psychosocial" ;

*PDSA;
 data include1; *PDSA;
  set jhsV1.pdsa(keep = subjid  pdsa6a  pdsa18a pdsa18b pdsa28a 
                           pdsa28b pdsa28c pdsa28d pdsa28e pdsa28f 
                           pdsa28g pdsa29  pdsa30);
  by subjid;
    
  *Create renamed duplicates for formulas;
  jobtitle    = pdsa6a;
  edu         = pdsa18a;
  ged         = pdsa18b;
  fmlyincome  = pdsa28a;
  fmlyinc10k  = pdsa28f;
  fmlyinc25k  = pdsa28g;
  fmlyinc35k  = pdsa28b;
  fmlyinc50k  = pdsa28c;
  fmlyinc75k  = pdsa28d;
  fmlyinc100k = pdsa28e;
  selfincome  = pdsa29;
  fmlysize    = pdsa30;
  run;

*OCCODE;
  data include2; *OCCODE;
    set jhsV1.occode_dv (keep = subjid soccode);
    by subjid;

    *Create renamed duplicates for formulas;
    soccode2 = (substr(soccode, 1, 2) + 0); *First two digits;
    run;

*Psychosocial Working Group;
  data include3;
 	set psychsoc.deriveddis01 (keep = subjid dis01ed dis01lt dis01bd);
	by subjid;

	*Rename;
	rename 	dis01ed = dailyDiscr
			    dis01lt = lifetimeDiscrm
			    dis01bd = discrmBurden ;
	run;

*Working group: depression ;
  data include4;
 	set psychsoc.derivedmood01(keep = subjid dps01);
	by subjid;

	*Rename;
	rename 	dps01 = depression ;
	run;

*Working group: stress ;
  data include5;
 	set psychsoc.derivedsts01(keep = subjid sts01tg sts01wsi);
	by subjid;

	*Rename;
	rename 	sts01tg  = perceivedStress
			    sts01wsi = weeklyStress ; 
	run;


*analysis;
  data include6; *analysis;
    set analysis(keep = subjid V1date);
    by subjid;

    *Create renamed duplicates for formulas;
    visitYear = year(V1date);
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
  proc print data = include; where inc1=0 and inc2=1;run; *(n=6);
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

*Combine 1-3 & 4;
data include; *Combine 1-3 & 4;
  merge include(in = in1)
        include4(in = in2);
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

*Combine 1-4 & 5;
data include; *Combine 1-4 & 5;
  merge include(in = in1)
        include5(in = in2);
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

*Combine 1-5 & 6;
data include; *Combine 1-5 & 6;
  merge include(in = in1)
        include6(in = in2);
  by subjid;
    inc1 = in1;
    inc2 = in2;
    if first.subjid then chkobs = 0;
    chkobs + 1;
  run;
  /*Checks;
  proc freq data = include; tables inc1 * inc2; run;
  proc print data = include; where inc1=1 and inc2=0;run; *(n=6);
  proc print data = include(where = (chkobs > 1)); run;
  */
  data include; *Drop temporary variables;
    set include;
    drop inc1 inc2 chkobs;
    run;

*Format and label variables ***************************************************;
data include; *Create Variables;
  set include; 
  by subjid; 

  *Variable: fmlyinc;
  if  fmlyincome in ('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K')                                      then fmlyinc = fmlyincome; else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc100k = 'Y'                               then fmlyinc = 'K';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc75k  = 'Y' & fmlyinc100k = 'N'           then fmlyinc = 'J';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc50k  = 'Y' & fmlyinc75k  = 'N'           then fmlyinc = 'I';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc35k  = 'Y' & fmlyinc50k  = 'N'           then fmlyinc = 'H';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc35k  = 'Y' & fmlyinc50k NOT in ('Y' 'N') then fmlyinc = 'H';        else 
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc25k  = 'Y'                               then fmlyinc = 'G';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc10k  = 'Y' & fmlyinc25k NOT in ('Y' 'N') then fmlyinc = 'E';        else 
  if fmlysize = 1 & (selfincome NOT in ('L' 'M') | missing(selfincome))                                then fmlyinc = selfincome; else
  fmlyinc =  " ";
  label fmlyinc = "Family Income Classification";
  format fmlyinc $fmlyinc.;

  *Variable: Income;

    *Family Size = 1;
    if fmlysize = 1 & visitYear in (2000 2001 2002 2003 2004) then do; 
      if fmlyinc in ("A" "B")         then Income = 1; else 
      if fmlyinc in ("C" "D" "E")     then Income = 2; else   
      if fmlyinc in ("F" "G")         then Income = 3; else 
      if fmlyinc in ("H" "I" "J" "K") then Income = 4;
      end;

    *Family Size = 2;
    if fmlysize = 2 & visitYear in (2000 2001 2002 2003 2004) then do; 
      if fmlyinc in ("A" "B" "C") then Income = 1; else 
      if fmlyinc in ("D" "E" "F") then Income = 2; else 
      if fmlyinc in ("G" "H")     then Income = 3; else 
      if fmlyinc in ("I" "J" "K") then Income = 4;
      end;

    *Family Size = 3;
    if fmlysize = 3 & visitYear in (2000) then do;
      if fmlyinc in ("A" "B" "C") then Income = 1; else 
      if fmlyinc in ("D" "E" "F") then Income = 2; else 
      if fmlyinc in ("G" "H")     then Income = 3; else 
      if fmlyinc in ("I" "J" "K") then Income = 4;
      end;

    if fmlysize = 3 & visitYear in (2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D") then Income = 1; else 
      if fmlyinc in ("E" "F")         then Income = 2; else 
      if fmlyinc in ("G" "H")         then Income = 3; else 
      if fmlyinc in ("I" "J" "K")     then Income = 4;
      end;

    *Family Size = 4;
    if fmlysize = 4 & visitYear in (2000) then do;
      if fmlyinc in ("A" "B" "C" "D") then Income = 1; else 
      if fmlyinc in ("E" "F" "G")     then Income = 2; else 
      if fmlyinc in ("H" "I")         then Income = 3; else 
      if fmlyinc in ("J" "K")         then Income = 4;
      end;
      
    if fmlysize = 4 & visitYear in (2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E") then Income = 1; else 
      if fmlyinc in ("F" "G")             then Income = 2; else 
      if fmlyinc in ("H" "I")             then Income = 3; else 
      if fmlyinc in ("J" "K")             then Income = 4;
      end;

    *Family Size = 5;
    if fmlysize = 5 & visitYear in (2000 2001 2002 2003) then do;
      if fmlyinc in ("A" "B" "C" "D" "E") then Income = 1; else 
      if fmlyinc in ("F" "G")             then Income = 2; else 
      if fmlyinc in ("H" "I")             then Income = 3; else 
      if fmlyinc in ("J" "K")             then Income = 4;
      end;

    if fmlysize = 5 & visitYear in (2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 6;
    if fmlysize = 6 & visitYear in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 7;
    if fmlysize = 7 & visitYear in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 8;
    if fmlysize = 8 & visitYear in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F" "G") then Income = 1; else 
      if fmlyinc in ("H")                         then Income = 2; else 
      if fmlyinc in ("I" "J")                     then Income = 3; else 
      if fmlyinc in ("K")                         then Income = 4;
      end;

    *Family Size = 9;
    if fmlysize = 9 & visitYear in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F" "G") then Income = 1; else 
      if fmlyinc in ("H")                         then Income = 2; else 
      if fmlyinc in ("I" "J")                     then Income = 3; else 
      if fmlyinc in ("K")                         then Income = 4;
      end;

  if fmlyinc in ("L" "M") then Income = .;

  label  Income = "Income Status";  
  format Income inc.;

  *Variable: occupation;
  if 11 <= soccode2 <= 29 then occupation = 1;  else
  if 31 <= soccode2 <= 39 then occupation = 2;  else
  if 41 <= soccode2 <= 43 then occupation = 3;  else
  if 44 <= soccode2 <= 45 then occupation = 4;  else
  if 47 <= soccode2 <= 49 then occupation = 5;  else
  if 51 <= soccode2 <= 53 then occupation = 6;  else
  if soccode2 = 55        then occupation = 7;  else
  if soccode2 = 57        then occupation = 8;  else
  if soccode2 = 58        then occupation = 9;  else
  if soccode2 = 59        then occupation = 10; else
  if soccode2 = 60        then occupation = 11; else
  if soccode2 = 61        then occupation = 12; else
  if missing(soccode2)    then occupation = .;  else
  occupation = 13;

  label occupation = "Occupational Status";
  format occupation occup.;
/*
  *Variable: Education;
  if 0  <= edu <  12 then Education = 1; else
  if 12 <= edu <= 13 then Education = 2; else
  if ged  = 'Y'      then Education = 3; else
  if edu  = 14       then Education = 4; else
  if edu  = 15       then Education = 5; else
  if edu  = 16       then Education = 6; else
  if edu  = 17       then Education = 7; else
  if edu  = 18       then Education = 8; else
  if edu >= 19       then Education = 9; else
  Education = .;

  label Education = "Educational Status";
  format Education edu.;
*/

  *Variable: edu3cat;
  if (0 >= edu) & (edu < 12) & (ged  = 'N') then edu3cat = 0; else
  if (edu in (12, 13)) | (ged  = 'Y')       then edu3cat = 1; else
  if (edu >= 14) & (edu <= 19)              then edu3cat = 2; else 
                                                 edu3cat = .;

  label edu3cat = "Education Attainment Categorization";
  format edu3cat edu3cat.;

  *Variable: HSgrad;
  if 0  <= edu <  12 then HSgrad = 0; else
  if edu >=	12       then HSgrad = 1; else
  if ged  = 'Y'      then HSgrad = 1; else
                          HSgrad = .;

  label  HSgrad = "High School Graduate" ;
  format HSgrad ynfmt. ;

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
%let keep17psych = fmlyinc Income Occupation /*Education*/ HSgrad edu3cat dailyDiscr lifetimeDiscrm discrmBurden depression weeklyStress perceivedStress ; 

%put Section 17 Complete;
