*********************** Jackson Heart Study ************************;
************ Validation documentation creation programs ************;
***************************** VISIT 3 ******************************;

title;

********************************************************************;
****************** Create Validation documentation  ****************;
********************************************************************;

*Read in Validation Analysis Data;
data validation; set analysis.validation3; run;

options nonotes;
%put;
%put;
%put ***** Validation3 Dataset (Exam Visit 3) *****;

   ods results off;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-01-validation design.rtf";
    %include ADval3("2-3-01-validation design.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-02-validation demogs.rtf";
    %include ADval3("2-3-02-validation demogs.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-03-validation anthro.rtf";
    %include ADval3("2-3-03-validation anthro.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-04-validation meds.rtf";
    %include ADval3("2-3-04-validation meds.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-05-validation htn.rtf";
    %include ADval3("2-3-05-validation htn.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-06-validation dm.rtf";
    %include ADval3("2-3-06-validation dm.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-07-validation lipids.rtf";
    %include ADval3("2-3-07-validation lipids.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-08-validation biosp.rtf";
    %include ADval3("2-3-08-validation biosp.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-09-validation renal.rtf";
    %include ADval3("2-3-09-validation renal.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-14-validation stroke.rtf";
    %include ADval3("2-3-14-validation stroke.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-15-validation cvd.rtf";
    %include ADval3("2-3-15-validation cvd.sas");
  ods rtf close;

  /* Under review
  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-17-validation psychosoc.rtf";
    %include ADval3("2-3-17-validation psychosoc.sas");
  ods rtf close;
  */

  ods rtf file = "data\Analysis Data\3-results\validation3\2-3-18-validation lss.rtf";
    %include ADval3("2-3-18-validation lss.sas");
  ods rtf close;

  ods results on;

  %put;
  %put;

options notes;

%put Visit 3 Validation Results Complete (See data\Analysis Data\results\validation3);
%put;
%put;
