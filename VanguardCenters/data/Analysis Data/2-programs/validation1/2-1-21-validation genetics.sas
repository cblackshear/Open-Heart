********************************************************************;
********************* Section 21: Genetics *************************;
********************************************************************;

title1 "Section 21: Genetics";

*Variable List;
  *Continuous;                    
  %let contvar = ; 

  *Categorical;                   
  %let catvar  =  SickleCell rs73885319 rs60910145 APOL1G1 rs71785313 APOL1G2 APOL1risk 
                 /*rs2814778_rd*/ /*rs28362286_rd*/ /*rs7626962_rd*/ /*rs33930165_rd*/; 
                  
*Simple Data Listing & Summary Stats;
%simple;

 
proc freq data=validation;
tables   
       APOL1G1*rs73885319 
       APOL1G1*rs60910145 
       APOL1G2*rs71785313 
       APOL1risk*(APOL1G1 APOL1G2);
run; 

%put Section 21 Complete;
