********************************************************************;
****************** Section 16: Health Care **********************;
********************************************************************;
title1 "Section 16: Health Care";

*Variable List;
  *Continuous;                    
  %let contvar = ; 

  *Categorical;                   
  %let catvar  = PrivateIns  MedicaidIns MedicareIns  Insured VAIns   
                 InsuranceType  Insured PublicIns PublicInsType  PrivatePublicIns; 
                  
*Simple Data Listing & Summary Stats;
%simple;

%put Section 16 Complete;
