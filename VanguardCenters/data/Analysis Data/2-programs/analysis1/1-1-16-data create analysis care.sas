********************************************************************;
****************** Section 16: Healthcare Access *******************;
********************************************************************;

title "Section 16: Healthcare Access";

*HCAA;
data include1; *HCAA;
    set jhsV1.hcaa(keep = subjid hcaa7 hcaa8 hcaa9 hcaa10); 
    by subjid;

    *Create renamed duplicates for formulas;
    PrivateInsYN   = hcaa7; 
    MedicaidInsYN  = hcaa8; 
    MedicareInsYN  = hcaa9;
    VAInsYN        = hcaa10; 
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
data include; *create variables;
    set include1; 
    by subjid;

    *Variable: PrivateIns;
    if PrivateInsYN = 'Y' then PrivateIns = 1;
    if PrivateInsYN = 'N' then PrivateIns = 0;
    if PrivateInsYN = 'D' or missing(PrivateInsYN) then PrivateIns = .;
    label PrivateIns = "Private Insurance Status";
    format PrivateIns ynfmt.;

    *Variable: MedicaidIns;
    if MedicaidInsYN = 'Y' then MedicaidIns = 1;
    if MedicaidInsYN = 'N' then MedicaidIns = 0;
    if MedicaidInsYN = 'D' or missing(MedicaidInsYN) then MedicaidIns = .;
    label MedicaidIns = "Medicaid Insurance Status";
    format MedicaidIns ynfmt.;

    *Variable: MedicareIns;
    if MedicareInsYN = 'Y' then MedicareIns = 1;
    if MedicareInsYN = 'N' then MedicareIns = 0;
    if MedicareInsYN = 'D' or missing(MedicareInsYN) then MedicareIns = .;
    label MedicareIns = "Medicare Insurance Status";
    format MedicareIns ynfmt.;

    *Variable: VAIns;
    if VAInsYN = 'Y' then VAIns = 1;
    if VAInsYN = 'N' then VAIns = 0;
    if VAInsYN = 'D' or missing(VAInsYN) then VAIns = .;
    label VAIns = "VA Insurance Status";
    format VAIns ynfmt.;

    *Variable: InsuranceType;
    if (PrivateIns  = 0 & 
        MedicaidIns = 0 & 
        MedicareIns = 0 & 
        VAIns       = 0)
        then InsuranceType = 0; else 

    if (PrivateIns   = 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns ^= 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 1; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns ^= 1 & 
        VAIns        = 1) 
       then InsuranceType = 2; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns  = 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 3; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns  = 1 & 
        MedicareIns ^= 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 4; else 

    if (PrivateIns   = 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns ^= 1 & 
        VAIns        = 1) 
       then InsuranceType = 5; else 

    if (PrivateIns   = 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns  = 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 6; else 

    if (PrivateIns   = 1 & 
        MedicaidIns  = 1 & 
        MedicareIns ^= 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 7; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns  = 1 & 
        VAIns        = 1) 
       then InsuranceType = 8; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns  = 1 & 
        MedicareIns ^= 1 & 
        VAIns        = 1) 
       then InsuranceType = 9; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns  = 1 & 
        MedicareIns  = 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 10; else 

    if (PrivateIns   = 1 & 
        MedicaidIns ^= 1 & 
        MedicareIns  = 1 & 
        VAIns        = 1) 
       then InsuranceType = 11; else 

    if (PrivateIns   = 1 & 
        MedicaidIns  = 1 & 
        MedicareIns ^= 1 & 
        VAIns        = 1) 
       then InsuranceType = 12; else 

    if (PrivateIns   = 1 & 
        MedicaidIns  = 1 & 
        MedicareIns  = 1 & 
        VAIns       ^= 1) 
       then InsuranceType = 13; else 

    if (PrivateIns  ^= 1 & 
        MedicaidIns  = 1 & 
        MedicareIns  = 1 & 
        VAIns        = 1) 
       then InsuranceType = 14; else 

    if (PrivateIns   = 1 & 
        MedicaidIns  = 1 & 
        MedicareIns  = 1 & 
        VAIns        = 1) 
       then InsuranceType = 15; else 

    InsuranceType = .;

    label InsuranceType = "Type of Health Insurance" ;
    format InsuranceType instype.;    

    *Variable: Insured;
    if InsuranceType = 0      then Insured = 0; else 
    if InsuranceType > 0      then Insured = 1; else 
    if missing(InsuranceType) then Insured = .;    
    label Insured = "Visit 1 Health Insurance Status";
    format Insured ynfmt.;

    *Variable: PublicIns;
    if InsuranceType in (3 4 10)     then PublicIns = 1; else  
    if InsuranceType NOT in (3 4 10) then PublicIns = 0; else
    if missing(InsuranceType)        then PublicIns = .;
    label PublicIns = "Public Insurance Status";
    format PublicIns ynfmt.;

    *Variable: PublicInsType;
    if InsuranceType = 4  then PublicInsType = 1; else
    if InsuranceType = 3  then PublicInsType = 2; else
    if InsuranceType = 10 then PublicInsType = 3; else
    PublicInsType = .;
    label PublicInsType = " Public Insurance Type";
    format PublicInsType publinstyp.;

    *Variable: PrivatePublicIns;
    if InsuranceType = 0                                            then PrivatePublicIns = 0; else
    if InsuranceType = 1  | InsuranceType = 2  | InsuranceType = 5  then PrivatePublicIns = 1; else
    if InsuranceType = 3  | InsuranceType = 4  | InsuranceType = 10 then PrivatePublicIns = 2; else 
    if InsuranceType = 6  | InsuranceType = 7  | InsuranceType = 8  | InsuranceType = 9  |
       InsuranceType = 11 | InsuranceType = 12 | InsuranceType = 13 | InsuranceType = 14 | InsuranceType = 15
       then PrivatePublicIns = 3;
    else PrivatePublicIns = .;
    label PrivatePublicIns = "Public or Private Insurance";
    format PrivatePublicIns PrivPubl.; 
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
%let keep16care = PrivateIns  MedicaidIns  MedicareIns    VAIns             InsuranceType 
                  Insured     PublicIns    PublicInsType  PrivatePublicIns;

%put Section 16 Complete;
