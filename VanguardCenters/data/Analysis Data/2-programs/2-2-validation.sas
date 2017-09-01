*********************** Jackson Heart Study ************************;
************ Validation documentation creation programs ************;
***************************** VISIT 2 ******************************;

title;

********************************************************************;
****************** Create Validation documentation  ****************;
********************************************************************;

*Read in  Validation Analysis Data;
data validation; set analysis.validation2; run;

options nonotes;
%put;
%put;
%put ***** Validation2 Dataset (Exam Visit 2) *****;

  ods results off;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-01-validation design.rtf";
    %include ADval2("2-2-01-validation design.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-02-validation demog.rtf";
    %include ADval2("2-2-02-validation demogs.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-03-validation anthro.rtf";
    %include ADval2("2-2-03-validation anthro.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-04-validation meds.rtf";
    %include ADval2("2-2-04-validation meds.sas"); 
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-05-validation htn.rtf";
    %include ADval2("2-2-05-validation htn.sas");
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-06-validation dm.rtf";
    %include ADval2("2-2-06-validation dm.sas");
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-07-validation lipids.rtf";
    %include ADval2("2-2-07-validation lipids.sas");
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-08-validation biosp.rtf";
    %include ADval2("2-2-08-validation biosp.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-09-validation renal.rtf";
    %include ADval2("2-2-09-validation renal.sas");
	ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-13-validation ct.rtf";
    %include ADval2("2-2-13-validation ct.sas");
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-14-validation stroke.rtf";
    %include ADval2("2-2-14-validation stroke.sas");
  ods rtf close;

	ods rtf file = "data\Analysis Data\3-results\validation2\2-2-15-validation cvd.rtf";
    %include ADval2("2-2-15-validation cvd.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-18-validation lss.rtf";
    %include ADval2("2-2-18-validation lss.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation2\2-2-20-validation geocode.rtf";
    %include ADval2("2-2-20-validation geocode.sas");
  ods rtf close;

  ods results on;

  %put;
  %put;
options notes;

%put Visit 2 Validation Results Complete (See data\Analysis Data\results\validation2);
%put;
%put;
