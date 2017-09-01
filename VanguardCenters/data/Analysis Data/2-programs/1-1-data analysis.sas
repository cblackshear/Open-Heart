*********************** Jackson Heart Study ************************;
*************** Analysis Datasets creation programs ****************;
***************************** VISIT 1 ******************************;

title;

********************************************************************;
****************** Create Analysis datasets ************************;
********************************************************************;

options nonotes;
  %put;
  %put;
  %put ***** Analysis1 Dataset (Exam Visit 1)******;
  %include ADdat1("1-1-01-data create analysis design.sas"); 
  %include ADdat1("1-1-02-data create analysis demogs.sas"); 
  %include ADdat1("1-1-03-data create analysis anthro.sas"); 
  %include ADdat1("1-1-04-data create analysis meds.sas");
  %include ADdat1("1-1-05-data create analysis htn.sas"); 
  %include ADdat1("1-1-06-data create analysis dm.sas"); 
  %include ADdat1("1-1-07-data create analysis lipids.sas");
  %include ADdat1("1-1-08-data create analysis biosp.sas");
  %include ADdat1("1-1-09-data create analysis renal.sas"); 
  %include ADdat1("1-1-10-data create analysis resp.sas");
  %include ADdat1("1-1-11-data create analysis echo.sas");
  %include ADdat1("1-1-12-data create analysis ecg.sas"); 
  *%include ADdat1("1-1-13-data create analysis ct.sas"); *Not collected in Visit 1; 
  %include ADdat1("1-1-14-data create analysis stroke.sas"); 
  %include ADdat1("1-1-15-data create analysis cvd.sas"); 
  %include ADdat1("1-1-16-data create analysis care.sas"); 
  %include ADdat1("1-1-17-data create analysis psychosoc.sas"); 
  %include ADdat1("1-1-18-data create analysis lss.sas"); 
  %include ADdat1("1-1-19-data create analysis nutrition.sas"); 
  %include ADdat1("1-1-20-data create analysis geocode.sas"); 
  *%include ADdat1("1-1-21-data create analysis genetics.sas"); *Not released;
  %include ADdat1("1-1-22-data create analysis pa.sas"); 
  %put;
  %put;
options notes;

********************************************************************;

*Save the validation dataset (all analysis variables and intermediary creation variables);
data analysis.validation1; 
  set analysis;
  by subjid;
  run;

*Save analysis dataset (only variables in the datasets dictionary);
data analysis.analysis1; 
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
       &keep10resp
       &keep11echo
       &keep12ecg
       &keep14stroke
       &keep15cvd
       &keep16care
       &keep17psych
       &keep18lss
       &keep19bnutri
       &keep20geocode
       /*&keep21genetics*/
       &keep22pa;

  visit = 1; *Set the visit number;
  label visit = "JHS Exam Visit Number";
  run;

title;
