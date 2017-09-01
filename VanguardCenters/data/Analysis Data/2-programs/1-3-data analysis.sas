*********************** Jackson Heart Study ************************;
************** Analysis Data Sets creation programs ****************;
***************************** VISIT 3 ******************************;

title;

********************************************************************;
****************** Create Analysis datasets ************************;
********************************************************************;

options nonotes;
  %put;
  %put;
  %put ***** Analysis3 Dataset (Exam Visit 3)******;
  %include ADdat3("1-3-01-data create analysis design.sas"); 
  %include ADdat3("1-3-02-data create analysis demogs.sas"); 
  %include ADdat3("1-3-03-data create analysis anthro.sas"); 
  %include ADdat3("1-3-04-data create analysis meds.sas");
  %include ADdat3("1-3-05-data create analysis htn.sas"); 
  %include ADdat3("1-3-06-data create analysis dm.sas"); 
  %include ADdat3("1-3-07-data create analysis lipids.sas");
  %include ADdat3("1-3-08-data create analysis biosp.sas");
  %include ADdat3("1-3-09-data create analysis renal.sas"); 
  *%include ADdat3("1-3-10-data create analysis resp.sas");  *Not collected in Visit 3;
  *%include ADdat3("1-3-11-data create analysis echo.sas");  *Not collected in Visit 3; 
  %include ADdat3("1-3-12-data create analysis ecg.sas");   
  *%include ADdat3("1-3-13-data create analysis ct.sas");    *Not collected in Visit 3;
  %include ADdat3("1-3-14-data create analysis stroke.sas"); 
  %include ADdat3("1-3-15-data create analysis cvd.sas"); 
  *%include ADdat3("1-3-16-data create analysis care.sas");  *Not collected in Visit 3;
  %include ADdat3("1-3-17-data create analysis psychosoc.sas"); 
  %include ADdat3("1-3-18-data create analysis lss.sas"); 
  *%include ADdat3("1-3-19-data create analysis nutipa.sas"); *Not collected in Visit 3;
  *%include ADdat1("1-3-20-data create analysis geocode.sas"); *Not collected in Visit 3;
  *%include ADdat1("1-3-21-data create analysis genetics.sas"); *Not collected in Visit 3;
  %put;
  %put;
options notes;

********************************************************************;

*Save the validAnalysis dataset (all analysis variables and intermediary creation variables);
data analysis.validation3; 
  set analysis;
  by subjid;
  run;

*Save analysis dataset (only variables in the datasets dictionary);
data analysis.analysis3; 
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
       &keep12ecg
       &keep14stroke
       &keep15cvd
       &keep17psych
       &keep18lss;

  visit = 3; *Set the visit number;
  label visit = "JHS Exam Visit Number";
  run;

title;
