** Program/project: JHS Analysis Data;
** Original Author: JHS DCC;

/* 
Note 1: Project directories are set up as:
        Project -> 0-info     (Data Dictionary, Codebooks, Refs, General Info)
        Project -> 1-data     (datasets directory)
        Project -> 2-programs (statistical analysis programs directory)
        Project -> 3-results  (output of .rtf file & graphics file sas results)

Note 2: Additional libname statements assigned to read protected JHS dataset directories; 
*/

*Set system options like do not center or put a date on output, etc.;
options nocenter nodate nonumber ps = 150 linesize = 100 nofmterr;

*Assign root directory (VanguardCenters);
**************************************************************************************************;
* YOU MUST CHANGE THIS TO YOUR DIRECTORY STRUCTURE!:
**************************************************************************************************;
*Example 1: x 'cd C:\JHS\VanGuardCenters';
*Example 2; x 'cd C:\Users\cblackshear\Documents\Box Sync\JHS\CC\JHS01-StudyData\VanguardCenters';

  *Primary VC data archetypes;
  libname afu      "data\AFU";                                                           *Annual Follow-Up;
  libname analysis "data\Analysis Data\1-data";                                          *Analysis-Ready Datasets; 
  libname asn0023  "data\Ancillary Studies\ASN0023Diez Roux-Geocode 1 2\1-data";         *Environmental Datasets for Exams 1 and 2;
  libname asn0033  "data\Ancillary Studies\ASN0033Wilson-1000 Genomes Imputed\1-data";   *Datasets from 1000 Genomes study;
  libname asn0041  "data\Ancillary Studies\ASN0041Bidulescu-Adiponectin\1-data";         *Datasets from adiponectin study;
  libname asn0042  "data\Ancillary Studies\ASN0042Liu-CT\1-data";                        *Datasets from liver CT study; 
  libname asn0066  "data\Ancillary Studies\ASN0066Kulkarni-VAPLipoprotein\1-data";       *Datasets from VAP lipoprotein study;
  libname asn0069  "data\Ancillary Studies\ASN0069Taylor-Whole Exome Sequencing\1-data"; *Datasets from whole exome sequencing study;
  libname ssn0006  "data\Supplementary\SSN0006-Nutrition\1-data";                        *Datasets from nutrition supplementary project;
  libname ssn0007  "data\Supplementary\SSN0007-Physical Activity\1-data";                *Datasets from physical activity supplementary project;
  libname cohort   "data\Cohort\1-data";                                                 *Ptcpt Contacts, Deaths, LTFU; 
  libname dpass    "data\Supplementary\SSN0001-DPASS\1-data";                            *Datasets from the Diet and Physical Activity Sub-Study;
  libname lss      "data\Supplementary\SSN0003-LS7\1-data";                              *Life's Simple 7 working group data;
  libname psychsoc "working groups\Psychosocial\1-data";                                 *Psychosocial working group data;
  libname splmnt   "data\Cohort\1-data\JHS Cohort Frozen Files";                         *Supplementary and administrative cohort data;
  libname jhsV1    "data\Visit 1\1-data";                                                *"Raw" Exam 1 data; 
  libname jhsV2    "data\Visit 2\1-data";                                                *"Raw" Exam 2 data; 
  libname jhsV3    "data\Visit 3\1-data";                                                *"Raw" Exam 3 data; 

  *Set programs directory(s);
  filename pgmsV1 "data\Visit 1\2-programs"; 
  filename pgmsV2 "data\Visit 2\2-programs"; 
  filename pgmsV3 "data\Visit 3\2-programs"; 
  filename ADpgms "data\Analysis Data\2-programs"; 
  filename ADdat1 "data\Analysis Data\2-programs\analysis1"; 
  filename ADdat2 "data\Analysis Data\2-programs\analysis2"; 
  filename ADdat3 "data\Analysis Data\2-programs\analysis3"; 
  filename ADval1 "data\Analysis Data\2-programs\validation1"; 
  filename ADval2 "data\Analysis Data\2-programs\validation2";
  filename ADval3 "data\Analysis Data\2-programs\validation3";
  filename ADver1 "data\Analysis Data\2-programs\verification1"; 
  filename ADver2 "data\Analysis Data\2-programs\verification2";
  filename ADver3 "data\Analysis Data\2-programs\verification3";

  *Read in format statements;
  options nonotes;
    %include ADpgms("0-1-formats.sas"); *Read in Analysis Datasets format statements;
    %include pgmsV1("0-1-formats.sas"); *Read in formats from the JHS visit 1 catalogue;
    %include pgmsV2("0-1-formats.sas"); *Read in formats from the JHS visit 2 catalogue;
    %include pgmsV3("0-1-formats.sas"); *Read in formats from the JHS visit 3 catalogue;
  options notes;

 options fmtsearch = (analysis.formats asn0033.formats asn0042.formats asn0066.formats asn0069.formats jhsV1.v1formats jhsV2.v2formats jhsV3.v3formats);

**************************************************************************************************;
** Step 1) Create datasets;
**************************************************************************************************;

  *Clear work directory & *Read in macro(s) used in data creation programs;
  %include ADpgms("1-0-data analysis.sas"); 

  *1.1) Create Visit 1 Analysis-ready dataset *************************;

  *Instantiate empty dataset for V1 to house all variables;
  data analysis; 
    set cohort.visitdat(keep = subjid V1date); 
    if missing(V1date) then delete;
    label subjid = "Participant ID";
    label V1date = "Date of Clinic Visit Exam 1";
    run;

  *Call programs to create and add variables within each dataset section;
  %include ADpgms("1-1-data analysis.sas");
 

  *1.2) Create Visit 2 Analysis-ready dataset *************************;

  *Instantiate empty dataset for V2 to house all variables;
  data analysis;
    set cohort.visitdat(keep = subjid V1date V2date);
    if missing(V2date) then delete;
    label subjid = "Participant ID";
    label V2date = "Date of Clinic Visit Exam 2";
    run;

  *Call programs to create and add variables within each dataset section;
  %include ADpgms("1-2-data analysis.sas"); 


  *1.3) Create Visit 3 Analysis-ready dataset *************************;

  *Instantiate empty dataset for V3 to house all variables;
  data analysis; 
    set cohort.visitdat(keep = subjid V1date V2date V3date); 
    if missing(V3date) then delete;
    label subjid = "Participant ID";
    label V3date = "Date of Clinic Visit Exam 3";
    run;

  *Call programs to create and add variables within each dataset section;
  %include ADpgms("1-3-data analysis.sas");


  *1.4) Create longitudinal (long and wide) analysis datasets *********;

  *Create analysisLong dataset;
  data analysisLong;
    retain subjid visit; 
    set analysis.analysis1
        analysis.analysis2
        analysis.analysis3;
    by subjid;
    run;
  proc sort data=analysisLong out=analysisLong; by subjid visit; run;
  *Save analysis dataset;
  data analysis.analysisLong; set analysisLong; run;

  *Create analysisWide dataset;
  %let variables = &keep01design
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
                   &keep13ct
                   &keep14stroke
                   &keep15cvd
                   &keep16care
                   &keep17psych
                   &keep18lss
                   &keep19bnutri
                   &keep20geocode
                   /*&keep21genetics*/
                   &keep22pa;
  %reshape();

  *Save analysisWide dataset;
  data analysis.analysisWide; set analysisWide; run;


**************************************************************************************************;
** Step 2) Validation (EDA on analytic variables);
**************************************************************************************************;

*Read in macro(s) for use in validation programs;
%include ADpgms("2-0-validation.sas");


*2.1) Visit 1*************************************************************************************;
%include ADpgms("2-1-validation.sas"); 


*2.2) Visit 2*************************************************************************************;
%include ADpgms("2-2-validation.sas");


*2.3) Visit 3*************************************************************************************;
%include ADpgms("2-3-validation.sas"); 


/*
**************************************************************************************************;
** Step 3) Verification;
**************************************************************************************************;

*3.1) Visit 1*************************************************************************************;
%include ADpgms("3-1-verification.sas"); 


*3.2) Visit 2*************************************************************************************;
%include ADpgms("3-2-verification.sas");


*3.3) Visit 3*************************************************************************************;
%include ADpgms("3-3-verification.sas");
*/
