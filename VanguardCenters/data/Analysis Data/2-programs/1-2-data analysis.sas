*********************** Jackson Heart Study ************************;
*************** Analysis Datasets creation programs ****************;
***************************** VISIT 2 ******************************;

title;

********************************************************************;
****************** Create Analysis datasets ************************;
********************************************************************;

options nonotes;
  %put;
  %put;
  %put ***** Analysis2 Dataset (Exam Visit 2)******;
  %include ADdat2("1-2-01-data create analysis design.sas"); 
  %include ADdat2("1-2-02-data create analysis demogs.sas"); 
  %include ADdat2("1-2-03-data create analysis anthro.sas"); 
  %include ADdat2("1-2-04-data create analysis meds.sas");
  %include ADdat2("1-2-05-data create analysis htn.sas"); 
  %include ADdat2("1-2-06-data create analysis dm.sas"); 
  %include ADdat2("1-2-07-data create analysis lipids.sas");
  %include ADdat2("1-2-08-data create analysis biosp.sas");
  %include ADdat2("1-2-09-data create analysis renal.sas"); 
  *%include ADdat2("1-2-10-data create analysis resp.sas");  *Not collected in Visit 2;
  *%include ADdat2("1-2-11-data create analysis echo.sas");  *Not collected in Visit 2;
  *%include ADdat2("1-2-12-data create analysis ecg.sas");   *Not collected in Visit 2;
  %include ADdat2("1-2-13-data create analysis ct.sas");  
  %include ADdat2("1-2-14-data create analysis stroke.sas"); 
  %include ADdat2("1-2-15-data create analysis cvd.sas"); 
  *%include ADdat2("1-2-16-data create analysis care.sas");  *Not collected in Visit 2;
  *%include ADdat2("1-2-17-data create analysis psychosoc.sas"); *Not collected in Visit 2;
  %include ADdat2("1-2-18-data create analysis lss.sas"); 
  *%include ADdat2("1-2-19-data create analysis nutipa.sas"); *Not collected in Visit 2;
  %include ADdat2("1-2-20-data create analysis geocode.sas"); 
  *%include ADdat2("1-2-21-data create analysis genetics.sas"); *Not collected in Visit 2;
  %put;
  %put;
options notes;

********************************************************************;

*Save validation dataset (all analysis variables and intermediary creation variables);
data analysis.validation2; 
  set analysis;
  by subjid;
  run;

*Save analysis dataset (only variables in the datasets dictionary);
data analysis.analysis2; 
  retain subjid visit VisitDate;
  set analysis;
  keep subjid visit
       &keep01design
       &keep02demogs
       &keep03anthro
       &keep04meds
       &keep05htn
       &keep06dm
       &keep07lipids
       &keep08biosp
       &keep09renal
       &keep13ct
       &keep14stroke
       &keep15cvd
       &keep18lss
       &keep20geocode;

  visit = 2; *Set the visit number;
  label visit = "JHS Exam Visit Number";
  run;

title;
