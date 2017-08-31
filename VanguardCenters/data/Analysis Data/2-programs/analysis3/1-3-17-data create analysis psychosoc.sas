********************************************************************;
****************** Section 17: Psychosocial **********************;
********************************************************************;
 
title "Section 17: Psychosocial" ;

*PDSB;
data include1; *PDSB;
  set jhsv3.pdsb(keep = subjid  pdsb6   pdsb17a pdsb17b pdsb27a 
                                pdsb27b pdsb27c pdsb27d pdsb27e pdsb27f 
                                pdsb27g pdsb28  pdsb29);
  by subjid;
    
  *Create renamed duplicates for formulas;
  jobtitle      = pdsb6;
  edu           = pdsb17a;
  ged           = pdsb17b;
  fmlyincomeNUM = pdsb27a;
  fmlyinc10k    = pdsb27f;
  fmlyinc25k    = pdsb27g;
  fmlyinc35k    = pdsb27b;
  fmlyinc50k    = pdsb27c;
  fmlyinc75k    = pdsb27d;
  fmlyinc100k   = pdsb27e;
  selfincomeNUM = pdsb28;
  fmlysize      = pdsb29;
  run;

*analysis;
  data include2; *analysis;
    set analysis(keep = subjid V3date);
    by subjid;

    *Create renamed duplicates for formulas;
    visitYear = year(V3date);
    run;

*Psychosocial Working Group;
  data include3;
 	set psychsoc.deriveddis03 (keep = subjid dis03ed);
	by subjid;

	*Rename;
	rename 	dis03ed = dailyDiscr ;
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

**********************************************************************************;

*Create Variables;
data include; *Create Variables;
  set include; 
  by subjid; 

  *Variable: fmlyinc;
  if fmlyincomeNUM = 1  then fmlyincome = 'A';
  if fmlyincomeNUM = 2  then fmlyincome = 'B';
  if fmlyincomeNUM = 3  then fmlyincome = 'C';
  if fmlyincomeNUM = 4  then fmlyincome = 'D';
  if fmlyincomeNUM = 5  then fmlyincome = 'E';
  if fmlyincomeNUM = 6  then fmlyincome = 'F';
  if fmlyincomeNUM = 7  then fmlyincome = 'G';
  if fmlyincomeNUM = 8  then fmlyincome = 'H';
  if fmlyincomeNUM = 9  then fmlyincome = 'I';
  if fmlyincomeNUM = 10 then fmlyincome = 'J';
  if fmlyincomeNUM = 11 then fmlyincome = 'K';
  if fmlyincomeNUM = 12 then fmlyincome = 'L';

  if selfincomeNUM = 1  then selfincome = 'A';
  if selfincomeNUM = 2  then selfincome = 'B';
  if selfincomeNUM = 3  then selfincome = 'C';
  if selfincomeNUM = 4  then selfincome = 'D';
  if selfincomeNUM = 5  then selfincome = 'E';
  if selfincomeNUM = 6  then selfincome = 'F';
  if selfincomeNUM = 7  then selfincome = 'G';
  if selfincomeNUM = 8  then selfincome = 'H';
  if selfincomeNUM = 9  then selfincome = 'I';
  if selfincomeNUM = 10 then selfincome = 'J';
  if selfincomeNUM = 11 then selfincome = 'K';
  if selfincomeNUM = 12 then selfincome = 'L';
  if selfincomeNUM = 13 then selfincome = 'M';

  if  fmlyincome in ('A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K')                                then fmlyinc = fmlyincome; else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc100k = 1                           then fmlyinc = 'K';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc75k  = 1 & fmlyinc100k = 2         then fmlyinc = 'J';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc50k  = 1 & fmlyinc75k  = 2         then fmlyinc = 'I';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc35k  = 1 & fmlyinc50k  = 2         then fmlyinc = 'H';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc35k  = 1 & fmlyinc50k NOT in (1 2) then fmlyinc = 'H';        else 
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc25k  = 1                           then fmlyinc = 'G';        else
  if (fmlyincome in ('L' 'M') | missing(fmlyincome)) & fmlyinc10k  = 1 & fmlyinc25k NOT in (1 2) then fmlyinc = 'E';        else 
  if fmlysize = 1 & (selfincome NOT in ('L' 'M') | missing(selfincome))                          then fmlyinc = selfincome; else
  fmlyinc = .;
  label fmlyinc = "Family Income Classification";
  format fmlyinc $fmlyinc.;

  *Variable: Income;

  /* Needs updating
    *Family Size = 1;
    if fmlysize = 1 & interviewYEAR in (2000 2001 2002 2003 2004) then do; 
      if fmlyinc in ("A" "B")         then Income = 1; else 
      if fmlyinc in ("C" "D" "E")     then Income = 2; else   
      if fmlyinc in ("F" "G")         then Income = 3; else 
      if fmlyinc in ("H" "I" "J" "K") then Income = 4;
      end;

    *Family Size = 2;
    if fmlysize = 2 & interviewYEAR in (2000 2001 2002 2003 2004) then do; 
      if fmlyinc in ("A" "B" "C") then Income = 1; else 
      if fmlyinc in ("D" "E" "F") then Income = 2; else 
      if fmlyinc in ("G" "H")     then Income = 3; else 
      if fmlyinc in ("I" "J" "K") then Income = 4;
      end;

    *Family Size = 3;
    if fmlysize = 3 & interviewYEAR in (2000) then do;
      if fmlyinc in ("A" "B" "C") then Income = 1; else 
      if fmlyinc in ("D" "E" "F") then Income = 2; else 
      if fmlyinc in ("G" "H")     then Income = 3; else 
      if fmlyinc in ("I" "J" "K") then Income = 4;
      end;

    if fmlysize = 3 & interviewYEAR in (2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D") then Income = 1; else 
      if fmlyinc in ("E" "F")         then Income = 2; else 
      if fmlyinc in ("G" "H")         then Income = 3; else 
      if fmlyinc in ("I" "J" "K")     then Income = 4;
      end;

    *Family Size = 4;
    if fmlysize = 4 & interviewYEAR in (2000) then do;
      if fmlyinc in ("A" "B" "C" "D") then Income = 1; else 
      if fmlyinc in ("E" "F" "G")     then Income = 2; else 
      if fmlyinc in ("H" "I")         then Income = 3; else 
      if fmlyinc in ("J" "K")         then Income = 4;
      end;
      
    if fmlysize = 4 & interviewYEAR in (2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E") then Income = 1; else 
      if fmlyinc in ("F" "G")             then Income = 2; else 
      if fmlyinc in ("H" "I")             then Income = 3; else 
      if fmlyinc in ("J" "K")             then Income = 4;
      end;

    *Family Size = 5;
    if fmlysize = 5 & interviewYEAR in (2000 2001 2002 2003) then do;
      if fmlyinc in ("A" "B" "C" "D" "E") then Income = 1; else 
      if fmlyinc in ("F" "G")             then Income = 2; else 
      if fmlyinc in ("H" "I")             then Income = 3; else 
      if fmlyinc in ("J" "K")             then Income = 4;
      end;

    if fmlysize = 5 & interviewYEAR in (2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 6;
    if fmlysize = 6 & interviewYEAR in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 7;
    if fmlysize = 7 & interviewYEAR in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F") then Income = 1; else 
      if fmlyinc in ("G" "H")                 then Income = 2; else 
      if fmlyinc in ("I" "J")                 then Income = 3; else 
      if fmlyinc in ("K")                     then Income = 4;
      end;

    *Family Size = 8;
    if fmlysize = 8 & interviewYEAR in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F" "G") then Income = 1; else 
      if fmlyinc in ("H")                         then Income = 2; else 
      if fmlyinc in ("I" "J")                     then Income = 3; else 
      if fmlyinc in ("K")                         then Income = 4;
      end;

    *Family Size = 9;
    if fmlysize = 9 & interviewYEAR in (2000 2001 2002 2003 2004) then do;
      if fmlyinc in ("A" "B" "C" "D" "E" "F" "G") then Income = 1; else 
      if fmlyinc in ("H")                         then Income = 2; else 
      if fmlyinc in ("I" "J")                     then Income = 3; else 
      if fmlyinc in ("K")                         then Income = 4;
      end;

  if fmlyinc in ("L" "M") then Income = .;
  */

  label  Income = "Income Status";  
  format Income inc.;
  
  *Variable: occupation;
  occupation = .; *Not collected in Visit 3;

  *Variable: Education;
  if 0  <= edu <  12 then Education = 1; else
  if 12 <= edu <= 13 then Education = 2; else
  if ged  = 1        then Education = 3; else
  if edu  = 14       then Education = 4; else
  if edu  = 15       then Education = 5; else
  if edu  = 16       then Education = 6; else
  if edu  = 17       then Education = 7; else
  if edu  = 18       then Education = 8; else
  if edu >= 19       then Education = 9; else
  Education = .;

  label Education = "Educational Status";
  format Education edu.;

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

%put Section 17 Complete;
