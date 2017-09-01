*********************** Jackson Heart Study ************************;
************ Validation documentation creation programs ************;
***************************** VISIT 1 ******************************;

title;

********************************************************************;
****************** Create Validation documentation  ****************;
********************************************************************;

*Read in Validation Analysis Data;
data validation; set analysis.validation1; run;

options nonotes;
%put;
%put;
%put ***** Validation1 Dataset (Exam Visit 1) *****;

  ods results off;
  ods graphics on /loessmaxobs = 5400;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-01-validation design.rtf";
    %include ADval1("2-1-01-validation design.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-02-validation demogs.rtf";
    %include ADval1("2-1-02-validation demogs.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-03-validation anthro.rtf";
    %include ADval1("2-1-03-validation anthro.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-04-validation meds.rtf";
    %include ADval1("2-1-04-validation meds.sas"); 
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-05-validation htn.rtf";
    %include ADval1("2-1-05-validation htn.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-06-validation dm.rtf";
    %include ADval1("2-1-06-validation dm.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-07-validation lipids.rtf";
    %include ADval1("2-1-07-validation lipids.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-08-validation biosp.rtf";
    %include ADval1("2-1-08-validation biosp.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-09-validation renal.rtf";
    %include ADval1("2-1-09-validation renal.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-10-validation resp.rtf";
    %include ADval1("2-1-10-validation resp.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-11-validation echo.rtf";
     %include ADval1("2-1-11-validation echo.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-12-validation ecg.rtf";
    %include ADval1("2-1-12-validation ecg.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-14-validation stroke.rtf";
    %include ADval1("2-1-14-validation stroke.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-15-validation cvd.rtf";
    %include ADval1("2-1-15-validation cvd.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-16-validation care.rtf";
    %include ADval1("2-1-16-validation care.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-17-validation psychosoc.rtf";
    %include ADval1("2-1-17-validation psychosoc.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-18-validation lss.rtf";
    %include ADval1("2-1-18-validation lss.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-19-validation nutrition.rtf";
    %include ADval1("2-1-19-validation nutrition.sas");
  ods rtf close;

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-20-validation geocode.rtf";
    %include ADval1("2-1-20-validation geocode.sas");
  ods rtf close;

  /*
  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-21-validation genetics.rtf";
    %include ADval1("2-1-21-validation genetics.sas");
  ods rtf close;
  */

  ods rtf file = "data\Analysis Data\3-results\validation1\2-1-22-validation pa.rtf";
    %include ADval1("2-1-22-validation pa.sas");
  ods rtf close;

  ods results on;

  %put;
  %put;
options notes;

%put Visit 1 Validation Results Complete (See data\Analysis Data\results\validation1);
%put;
%put;
