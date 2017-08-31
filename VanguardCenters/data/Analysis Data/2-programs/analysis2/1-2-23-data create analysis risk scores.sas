********************************************************************;
********************** Section 23: Risk Scores *********************;
********************************************************************;

title "Section 23: Risk Scores";


******10 Year Risk Estimate for Coronary Heart Disease using Framingham Point Scores;

*First, obtain eversmoker at visit 1;

*Merge analysis data set with analysiswide;
data smokedata; 
set analysis.analysiswide ;
run;

*sort before merging;
proc sort data=smokedata; by subjid; run;

*merge analysis with analysis wide;
data analysis;
merge smokedata (in=x) analysis (in=y);
by subjid;
if y=1;
run;

data include1;
	set analysis;
*Only include participants within specified age range;
	if age <= 30 | age > 74 then delete;
*Only include participants who have all covariates;
	if missing(age) then delete;
	if missing(totchol) then delete;
	if missing(hdl) then delete;
	if missing(sbp) then delete;
	if missing(diabetes) then delete;
	if missing(eversmokerV1) then delete;
	if missing(sex) then delete;
run;


data include1; set include1;

*For Males;

  *Framingham Point scores by age, for males;
  if sex="Male" & 30 < age <= 34 then agescoremen=-1;
  if sex="Male" & 34 < age <= 39 then agescoremen=0;
  if sex="Male" & 39 < age <= 44 then agescoremen=1;
  if sex="Male" & 44 < age <= 49 then agescoremen=2;
  if sex="Male" & 49 < age <= 54 then agescoremen=3;
  if sex="Male" & 54 < age <= 59 then agescoremen=4;
  if sex="Male" & 59 < age <= 64 then agescoremen=5;
  if sex="Male" & 64 < age <= 69 then agescoremen=6;
  if sex="Male" & 69 < age <= 74 then agescoremen=7;

  *Framingham Point Scoress by LDL-C (total cholesterol);
  if sex="Male" &       totchol <= 100 then cholscoremen=-3;
  if sex="Male" & 100 < totchol <= 129 then cholscoremen=0;
  if sex="Male" & 129 < totchol <= 159 then cholscoremen=0;
  if sex="Male" & 159 < totchol <= 190 then cholscoremen=1;
  if sex="Male" &       totchol >  190 then cholscoremen=2;

  *Framingham Point Scores by Smoking Status; 
  if sex="Male" & eversmokerV1=0 then smokescoremen=0;
  if sex="Male" & eversmokerV1=1 then smokescoremen=2;

  *Framingham Point Scores by HDL level; 
  if sex="Male" & .  <  hdl <  35 then hdlscoremen=2;
  if sex="Male" & 35 <= hdl <  44 then hdlscoremen=1;
  if sex="Male" & 44 <= hdl <  49 then hdlscoremen=0;
  if sex="Male" & 49 <= hdl <  59 then hdlscoremen=0;
  if sex="Male" &       hdl >= 59 then hdlscoremen=-2;

  *Framingham Point Scores by Systolic Blood Pressure; 
  if sex="Male" & .   <  sbp <  120  then sbpscoremen=0;
  if sex="Male" & 120 <= sbp <  129  then sbpscoremen=0;
  if sex="Male" & 129 <= sbp <  139  then sbpscoremen=1;
  if sex="Male" & 139 <= sbp <  159  then sbpscoremen=2;
  if sex="Male" &        sbp >= 159  then sbpscoremen=3;

  *Framingham Point Score by Diabetes Status;
  if sex="Male" & diabetes=0 then diabetesscoremen=0;
  if sex="Male" & diabetes=1 then diabetesscoremen=2;

  *Sum of all categories to find out individual Framingham Risk Score;
  F_Male = sum(OF agescoremen cholscoremen hdlscoremen sbpscoremen diabetesscoremen smokescoremen);

  *10-Year Risk by total Framingham Point Scores for Males; 
  if sex="Male" & .  <  F_Male <=-3  then frs_chdtenyrrisk = 0.01;
  if sex="Male" & -2 <= F_Male <=-1  then frs_chdtenyrrisk = 0.02;
  if sex="Male" &       F_Male  = 0  then frs_chdtenyrrisk = 0.03;
  if sex="Male" & 1  <= F_Male <= 2  then frs_chdtenyrrisk = 0.40;
  if sex="Male" &       F_Male  = 3  then frs_chdtenyrrisk = 0.06;
  if sex="Male" &       F_Male  = 4  then frs_chdtenyrrisk = 0.07;
  if sex="Male" &       F_Male  = 5  then frs_chdtenyrrisk = 0.09;
  if sex="Male" &       F_Male  = 6  then frs_chdtenyrrisk = 0.11;
  if sex="Male" &       F_Male  = 7  then frs_chdtenyrrisk = 0.14;
  if sex="Male" &       F_Male  = 8  then frs_chdtenyrrisk = 0.18;
  if sex="Male" &       F_Male  = 9  then frs_chdtenyrrisk = 0.22;
  if sex="Male" &       F_Male  = 10 then frs_chdtenyrrisk = 0.27;
  if sex="Male" &       F_Male  = 11 then frs_chdtenyrrisk = 0.33;
  if sex="Male" &       F_Male  = 12 then frs_chdtenyrrisk = 0.40;
  if sex="Male" &       F_Male  = 13 then frs_chdtenyrrisk = 0.47;
  if sex="Male" &       F_Male >= 14 then frs_chdtenyrrisk = 0.56; *added label >=.56;

*For Females;

  *Framinham Point Scores by Age Group;
  if sex="Female" & 30 < age <= 34 then agescorefe=-9;
  if sex="Female" & 34 < age <= 39 then agescorefe=-4;
  if sex="Female" & 39 < age <= 44 then agescorefe=0;
  if sex="Female" & 44 < age <= 49 then agescorefe=3;
  if sex="Female" & 49 < age <= 54 then agescorefe=6;
  if sex="Female" & 54 < age <= 59 then agescorefe=7;
  if sex="Female" & 59 < age <= 74 then agescorefe=8;

  *Framingham Point Scroes by LDL-C (total cholesterol);
  if sex="Female" &        totchol < 100 then cholscorefe=-2;
  if sex="Female" & 100 <= totchol < 159 then cholscorefe=0;
  if sex="Female" &        totchol >=159 then cholpointsfe=2;

  *Framingham Point Scores by Smoking Status; 
  if sex="Female" & eversmokerV1=0 then smokescorefe=0;
  if sex="Female" & eversmokerV1=1 then smokescorefe=2;

  *Framingham Point Scores by HDL level; 
  if sex="Female" & .  <  hdl <  35 then hdlscorefe=5;
  if sex="Female" & 35 <= hdl <  44 then hdlscorefe=2;
  if sex="Female" & 44 <= hdl <  49 then hdlscorefe=1;
  if sex="Female" & 49 <= hdl <  59 then hdlscorefe=0;
  if sex="Female" &       hdl >= 59 then hdlscorefe=-3;

  *Framingham Point Scores by Systolic Blood Pressure;
  if sex="Female" & .   < sbp <= 120 then sbpscorefe=-3;
  if sex="Female" & 120 < sbp <= 139 then sbpscorefem=0;
  if sex="Female" & 139 < sbp <= 159 then sbpscorefe=2;
  if sex="Female" &       sbp >  159 then sbpscorefe=3;

  *Framingham Point Score by Diabetes Status;
  if sex="Female" & diabetes=0 then diabetesscorefe=0;
  if sex="Female" & diabetes=1 then diabetesscorefe=4;

  *Sum of all categories to find out individual Framingham Risk Score;
  F_female = sum(OF agescorefe cholscorefe hdlscorefe sbpscorefe diabetesscorefe smokescorefe);

  *10-Year Risk by total Framingham Point Scores for Females; 
  if sex="Female" & .  <  F_female <= -2 then frs_chdtenyrrisk = 0.01;
  if sex="Female" & -1 <= F_female <=  1 then frs_chdtenyrrisk = 0.02;
  if sex="Female" &  2 <= F_female <=  3 then frs_chdtenyrrisk = 0.03;
  if sex="Female" &       F_female  =  4 then frs_chdtenyrrisk = 0.04;
  if sex="Female" &       F_female  =  5 then frs_chdtenyrrisk = 0.05;
  if sex="Female" &       F_female  =  6 then frs_chdtenyrrisk = 0.06;
  if sex="Female" &       F_female  =  7 then frs_chdtenyrrisk = 0.07;
  if sex="Female" &       F_female  =  8 then frs_chdtenyrrisk = 0.08;
  if sex="Female" &       F_female  =  9 then frs_chdtenyrrisk = 0.09;
  if sex="Female" &       F_female  = 10 then frs_chdtenyrrisk = 0.11;
  if sex="Female" &       F_female  = 11 then frs_chdtenyrrisk = 0.13;
  if sex="Female" &       F_female  = 12 then frs_chdtenyrrisk = 0.15;
  if sex="Female" &       F_female  = 13 then frs_chdtenyrrisk = 0.17;
  if sex="Female" &       F_female  = 14 then frs_chdtenyrrisk = 0.200;
  if sex="Female" &       F_female  = 15 then frs_chdtenyrrisk=  0.24; 
  if sex="Female" &       F_female  = 16 then frs_chdtenyrrisk = 0.27; 
  if sex="Female" &       F_female >= 17 then frs_chdtenyrrisk = 0.32; *added label >=.32;
  format frs_chdtenyrrisk frs_chdtenyrrisk.;
  run;

*Only keep chdtenryrisk variable;
data include1;
  set include1(keep=subjid frs_chdtenyrrisk);
run;

 


******10-Year Risk Estimate Risk for Cardiovascular Disease using Framingham Point Scores;

data include2;
	set analysis;
*Only include participants within specified age range;
	if age <= 30 then delete;
*Only include participants who have all covariates;
	if missing(age) then delete;
	if missing(totchol) then delete;
	if missing(hdl) then delete;
	if missing(sbp) then delete;
	if missing(diabetes) then delete;
	if missing(eversmokerV1) then delete;
	if missing(sex) then delete;
	if missing(bpmeds) then delete;
run;

data include2; set include2;

*For Males;

  *Framingham Point scores by age, for males;
  if sex="Male" & 30 < age <= 34 then agescoremen=0;
  if sex="Male" & 34 < age <= 39 then agescoremen=2;
  if sex="Male" & 39 < age <= 44 then agescoremen=5;
  if sex="Male" & 44 < age <= 49 then agescoremen=6;
  if sex="Male" & 49 < age <= 54 then agescoremen=8;
  if sex="Male" & 54 < age <= 59 then agescoremen=10;
  if sex="Male" & 59 < age <= 64 then agescoremen=11;
  if sex="Male" & 64 < age <= 69 then agescoremen=12;
  if sex="Male" & 69 < age <= 74 then agescoremen=14;
  if sex="Male" &      age >  75 then agescoremen=15;

  *Framingham Point Scroes by LDL-C (total cholesterol);
  if sex="Male" &        totchol <  160 then cholscoremen=0;
  if sex="Male" & 160 <= totchol <  199 then cholscoremen=1;
  if sex="Male" & 199 <= totchol <  239 then cholscoremen=2;
  if sex="Male" & 239 <= totchol <  279 then cholscoremen=3;
  if sex="Male" &        totchol >= 279 then cholscoremen=4;

  *Framingham Point Scores by Smoking Status;
  if sex="Male" & eversmokerV1=0 then smokescoremen=0;
  if sex="Male" & eversmokerV1=1 then smokescoremen=4;

  *Framingham Point Scores by HDL level; 
  if sex="Male" & .  <  hdl <  35 then hdlscoremen=2;
  if sex="Male" & 35 <= hdl <  44 then hdlscoremen=1;
  if sex="Male" & 44 <= hdl <  49 then hdlscoremen=0;
  if sex="Male" & 49 <= hdl <  59 then hdlscoremen=-1;
  if sex="Male" &       hdl >= 59 then hdlscoremen=-2;

  *Framingham Point Scores by Systolic Blood Pressure; 
  if sex="Male" & .   <  sbp <  120 then sbpscoremen=-2;
  if sex="Male" & 120 <= sbp <  129 then sbpscoremen=0;
  if sex="Male" & 129 <= sbp <  139 then sbpscoremen=1;
  if sex="Male" & 139 <= sbp <  159 then sbpscormen=2;
  if sex="Male" &        sbp >= 159 then sbpscoremen=3;

  *Framingham Point Score by Diabetes Status;
  if sex="Male" & diabetes=0 then diabetesscoremen=0;
  if sex="Male" & diabetes=1 then diabetesscoremen=3;

  *Sum of all categories to find out individual Framingham Risk Score;
  F_male = sum(OF agescoremen cholscoremen smokescoremen hdlscoremen sbpscoremen diabetesscoremen);

  *10-Year Risk by total Framingham Point Scores for Males;
  if sex="Male" & .< F_male <= -3 then frs_cvdtenyrrisk = 0.010; *added label <.01;
  if sex="Male" &    F_male  = -2 then frs_cvdtenyrrisk = 0.011;
  if sex="Male" &    F_male  = -1 then frs_cvdtenyrrisk = 0.014;
  if sex="Male" &    F_male  =  0 then frs_cvdtenyrrisk = 0.016;
  if sex="Male" &    F_male  =  1 then frs_cvdtenyrrisk = 0.019;
  if sex="Male" &    F_male  =  2 then frs_cvdtenyrrisk = 0.023;
  if sex="Male" &    F_male  =  3 then frs_cvdtenyrrisk = 0.028;
  if sex="Male" &    F_male  =  4 then frs_cvdtenyrrisk = 0.033;
  if sex="Male" &    F_male  =  5 then frs_cvdtenyrrisk = 0.039;
  if sex="Male" &    F_male  =  6 then frs_cvdtenyrrisk = 0.047;
  if sex="Male" &    F_male  =  7 then frs_cvdtenyrrisk = 0.056;
  if sex="Male" &    F_male  =  8 then frs_cvdtenyrrisk = 0.067;
  if sex="Male" &    F_male  =  9 then frs_cvdtenyrrisk = 0.079;
  if sex="Male" &    F_male  = 10 then frs_cvdtenyrrisk = 0.094;
  if sex="Male" &    F_male  = 11 then frs_cvdtenyrrisk = 0.112;
  if sex="Male" &    F_male  = 12 then frs_cvdtenyrrisk = 0.132;
  if sex="Male" &    F_male  = 13 then frs_cvdtenyrrisk = 0.156;
  if sex="Male" &    F_male  = 14 then frs_cvdtenyrrisk = 0.184;
  if sex="Male" &    F_male  = 15 then frs_cvdtenyrrisk = 0.216;
  if sex="Male" &    F_male  = 16 then frs_cvdtenyrrisk = 0.253;
  if sex="Male" &    F_male  = 17 then frs_cvdtenyrrisk = 0.294;
  if sex="Male" &    F_male >= 18 then frs_cvdtenyrrisk = 0.300; *added label >=.30;

*For Females;

  *Framinham Point Scores by Age Group;
  if sex="Female" & 30 < age <= 34 then agescorefe=0;
  if sex="Female" & 34 < age <= 39 then agescorefe=2;
  if sex="Female" & 39 < age <= 44 then agescorefe=4;
  if sex="Female" & 44 < age <= 49 then agescorefe=5;
  if sex="Female" & 49 < age <= 54 then agescorefe=7;
  if sex="Female" & 54 < age <= 59 then agescorefe=8;
  if sex="Female" & 59 < age <= 64 then agescorefe=9;
  if sex="Female" & 64 < age <= 69 then agescorefe=10;
  if sex="Female" & 69 < age <= 74 then agescorefe=11;
  if sex="Female" &      age >  74 then agescorefe=12;

  *Framingham Point Scroes by LDL-C (total cholesterol);
  if sex="Female" &        totchol <  160 then cholscorefe=0;
  if sex="Female" & 160 <= totchol <  199 then cholscorefe=1;
  if sex="Female" & 199 <= totchol <  239 then cholscorefe=3;
  if sex="Female" & 239 <= totchol <  279 then cholscorefe=4;
  if sex="Female" &        totchol >= 279 then cholscorefe=5;

  *Framingham Point Scores by Smoking Status; 
  if sex="Female" & eversmokerV1=0 then smokescorefe=0;
  if sex="Female" & eversmokerV1=1 then smokescorefe=3;

  *Framingham Point Scores by HDL level; 
  if sex="Female" & .  <  hdl <  35 then hdlscorefe=2;
  if sex="Female" & 35 <= hdl <  44 then hdlscorefe=1;
  if sex="Female" & 44 <= hdl <  49 then hdlscorefe=0;
  if sex="Female" & 49 <= hdl <  59 then hdlscorefe=-1;
  if sex="Female" &       hdl >= 59 then hdlscorefe=-2;

  *Framingham Point Scores by Systolic Blood Pressure Treatment;
  if sex="Female" & bpmeds=0 and .   <  sbp <  120 then sbpscorefe=-3;
  if sex="Female" & bpmeds=0 and 120 <= sbp <  129 then sbpscorefe=0;
  if sex="Female" & bpmeds=0 and 129 <= sbp <  139 then sbpscorefe=1;
  if sex="Female" & bpmeds=0 and 139 <= sbp <  149 then sbpscorefe=2;
  if sex="Female" & bpmeds=0 and 149 <= sbp <  159 then sbpscorefe=4;
  if sex="Female" & bpmeds=0 and        sbp >= 159 then sbpscorefe=5;

  if sex="Female" & bpmeds=1 and        sbp <  120 then sbpscorefe=-1;
  if sex="Female" & bpmeds=1 and 120 <= sbp <  129 then sbpscorefe=2;
  if sex="Female" & bpmeds=1 and 129 <= sbp <  139 then sbpscorefe=3;
  if sex="Female" & bpmeds=1 and 139 <= sbp <  149 then sbpscorefe=5;
  if sex="Female" & bpmeds=1 and 149 <= sbp <  159 then sbpscorefe=6;
  if sex="Female" & bpmeds=1 and        sbp >= 159 then sbpscorefe=7;

  *Framingham Point Score by Diabetes Status;
  if sex="Female" & diabetes=0 then diabetesscorefe=0;
  if sex="Female" & diabetes=1 then diabetesscorefe=4;

  *Sum of all categories to find out individual Framingham Risk Score;
  F_female = sum(OF agescorefe cholscorefe hdlscorefe sbpscorefe diabetesscorefe smokescorefe);

  *10-Year Risk by total Framingham Point Scores for Females; 
  if sex="Female" & .< F_female <= -2 then frs_cvdtenyrrisk = 0.010; /* Added label <=0.01 */
  if sex="Female" &    F_female  = -1 then frs_cvdtenyrrisk = 0.010;
  if sex="Female" &    F_female  =  0 then frs_cvdtenyrrisk = 0.012;
  if sex="Female" &    F_female  =  1 then frs_cvdtenyrrisk = 0.015;
  if sex="Female" &    F_female  =  2 then frs_cvdtenyrrisk = 0.017;
  if sex="Female" &    F_female  =  3 then frs_cvdtenyrrisk = 0.020;
  if sex="Female" &    F_female  =  4 then frs_cvdtenyrrisk = 0.024;
  if sex="Female" &    F_female  =  5 then frs_cvdtenyrrisk = 0.028;
  if sex="Female" &    F_female  =  6 then frs_cvdtenyrrisk = 0.033;
  if sex="Female" &    F_female  =  7 then frs_cvdtenyrrisk = 0.039;
  if sex="Female" &    F_female  =  8 then frs_cvdtenyrrisk = 0.045;
  if sex="Female" &    F_female  =  9 then frs_cvdtenyrrisk = 0.053;
  if sex="Female" &    F_female  = 10 then frs_cvdtenyrrisk = 0.630;
  if sex="Female" &    F_female  = 11 then frs_cvdtenyrrisk = 0.730;
  if sex="Female" &    F_female  = 12 then frs_cvdtenyrrisk = 0.086;
  if sex="Female" &    F_female  = 13 then frs_cvdtenyrrisk = 0.100;
  if sex="Female" &    F_female  = 14 then frs_cvdtenyrrisk = 0.117;
  if sex="Female" &    F_female  = 15 then frs_cvdtenyrrisk = 0.137; 
  if sex="Female" &    F_female  = 16 then frs_cvdtenyrrisk = 0.159;  
  if sex="Female" &    F_female  = 17 then frs_cvdtenyrrisk = 0.185; 
  if sex="Female" &    F_female  = 18 then frs_cvdtenyrrisk = 0.215;
  if sex="Female" &    F_female  = 19 then frs_cvdtenyrrisk = 0.248;
  if sex="Female" &    F_female  = 20 then frs_cvdtenyrrisk = 0.285;
  if sex="Female" &    F_female >= 21 then frs_cvdtenyrrisk = 0.300; * Added label >=0.300;
  format frs_cvdtenyrrisk frs_cvdtenyrrisk.;


*Only keep cvd variable;
data include2;
  set include2(keep=subjid frs_cvdtenyrrisk);
run;

*Round risk score;
data include2; set include2;
  frs_cvdtenyrrisk=round(frs_cvdtenyrrisk, .01);
run;


******10-Year Risk Estimate Risk for Cardiovascular Disease using Framingham Point Scores based on the Adult Treatment Panel III;

data include3;
	set analysis;
*Only include participants within specified age range;
	if age <= 20 | age > 79 then delete;
*Only include participants who have all covariates;
	if missing(age) then delete;
	if missing(totchol) then delete;
	if missing(hdl) then delete;
	if missing(sbp) then delete;
	if missing(eversmokerV1) then delete;
	if missing(sex) then delete;
	if missing(bpmeds) then delete;
run;

data include3; set include3;

  *age categories for both men and women, to be used for cholesterol and smoking score;
  if 20 < age <= 39 then agecategory=1;
  if 39 < age <= 49 then agecategory=2; 
  if 49 < age <= 59 then agecategory=3;
  if 59 < age <= 69 then agecategory=4;
  if 69 < age <= 79 then agecategory=5;

*For Males;

  *Framingham Point Scores by Age Group;
  if sex="Male" & 20 < age <= 34 then agescoremen=-9;
  if sex="Male" & 34 < age <= 39 then agescoremen=-4;
  if sex="Male" & 39 < age <= 44 then agescoremen=0;
  if sex="Male" & 44 < age <= 49 then agescoremen=3;
  if sex="Male" & 49 < age <= 54 then agescoremen=6;
  if sex="Male" & 54 < age <= 59 then agescoremen=8;
  if sex="Male" & 59 < age <= 64 then agescoremen=10;
  if sex="Male" & 64 < age <= 69 then agescoremen=11;
  if sex="Male" & 69 < age <= 74 then agescoremen=12;
  if sex="Male" & 74 < age <= 79 then agescoremen=13;

  *Creating cholesterol score;
  if agecategory=1 and       totchol <= 160 then cholscore=1;
  if agecategory=1 and 160 < totchol <= 199 then cholscore=2;
  if agecategory=1 and 199 < totchol <= 239 then cholscore=3;
  if agecategory=1 and 239 < totchol <= 279 then cholscore=4;
  if agecategory=1 and       totchol >  279 then cholscore=5;

  if agecategory=2 and       totchol <= 160 then cholscore=6;
  if agecategory=2 and 160 < totchol <= 199 then cholscore=7;
  if agecategory=2 and 199 < totchol <= 239 then cholscore=8;
  if agecategory=2 and 239 < totchol <= 279 then cholscore=9;
  if agecategory=2 and       totchol >  279 then cholscore=10;

  if agecategory=3 and       totchol <= 160 then cholscore=11;
  if agecategory=3 and 160 < totchol <= 199 then cholscore=12;
  if agecategory=3 and 199 < totchol <= 239 then cholscore=13;
  if agecategory=3 and 239 < totchol <= 279 then cholscore=14;
  if agecategory=3 and       totchol >  279 then cholscore=15;
 
  if agecategory=4 and       totchol <= 160 then cholscore=16;
  if agecategory=4 and 160 < totchol <= 199 then cholscore=17;
  if agecategory=4 and 199 < totchol <= 239 then cholscore=18;
  if agecategory=4 and 239 < totchol <= 279 then cholscore=19;
  if agecategory=4 and       totchol >  279 then cholscore=20;

  if agecategory=5 and       totchol <= 160 then cholscore=21;
  if agecategory=5 and 160 < totchol <= 199 then cholscore=22;
  if agecategory=5 and 199 < totchol <= 239 then cholscore=23;
  if agecategory=5 and 239 < totchol <= 279 then cholscore=24;
  if agecategory=5 and       totchol >  279 then cholscore=25;

  *Framingham Cholesterol Points based on gender and age;
  if sex="Male" & cholscore=1 then cholscoremen=0;
  if sex="Male" & cholscore=2 then cholscoremen=4;
  if sex="Male" & cholscore=3 then cholscoremen=7;
  if sex="Male" & cholscore=4 then cholscoremen=9;
  if sex="Male" & cholscore=5 then cholscoremen=11;

  if sex="Male" & cholscore=6 then cholscoremen=0;
  if sex="Male" & cholscore=7 then cholscoremen=3;
  if sex="Male" & cholscore=8 then cholscoremen=5;
  if sex="Male" & cholscore=9 then cholscoremen=6;
  if sex="Male" & cholscore=10 then cholscoremen=8;

  if sex="Male" & cholscore=11 then cholscoremen=0;
  if sex="Male" & cholscore=12 then cholscoremen=2;
  if sex="Male" & cholscore=13 then cholscoremen=3;
  if sex="Male" & cholscore=14 then cholscoremen=4;
  if sex="Male" & cholscore=15 then cholscoremen=5;

  if sex="Male" & cholscore=16 then cholscoremen=0;
  if sex="Male" & cholscore=17 then cholscoremen=1;
  if sex="Male" & cholscore=18 then cholscoremen=1;
  if sex="Male" & cholscore=19 then cholscoremen=2;
  if sex="Male" & cholscore=20 then cholscoremen=3;

  if sex="Male" & cholscore=21 then cholscoremen=0;
  if sex="Male" & cholscore=22 then cholscoremen=0;
  if sex="Male" & cholscore=23 then cholscoremen=0;
  if sex="Male" & cholscore=24 then cholscoremen=1;
  if sex="Male" & cholscore=25 then cholscoremen=1; 
 
  *Creating smoke score;
  if eversmokerV1=0 and agecategory=1 then smokescore=1;
  if eversmokerV1=0 and agecategory=2 then smokescore=2;
  if eversmokerV1=0 and agecategory=3 then smokescore=3;
  if eversmokerV1=0 and agecategory=4 then smokescore=4;
  if eversmokerV1=0 and agecategory=5 then smokescore=5;

  if eversmokerV1=1 and agecategory=1 then smokescore=6;
  if eversmokerV1=1 and agecategory=2 then smokescore=7;
  if eversmokerV1=1 and agecategory=3 then smokescore=8;
  if eversmokerV1=1 and agecategory=4 then smokescore=9;
  if eversmokerV1=1 and agecategory=5 then smokescore=10;

  *Framingham Points Scores by age and smoking status;
  if sex="Male" & smokescore=1 then smokescoremen=0;
  if sex="Male" & smokescore=2 then smokescoremen=0;
  if sex="Male" & smokescore=3 then smokescoremen=0;
  if sex="Male" & smokescore=4 then smokescoremen=0;
  if sex="Male" & smokescore=5 then smokescoremen=0;

  if sex="Male" & smokescore=6 then smokescoremen=8;
  if sex="Male" & smokescore=7 then smokescoremen=5;
  if sex="Male" & smokescore=8 then smokescoremen=3;
  if sex="Male" & smokescore=9 then smokescoremen=1;
  if sex="Male" & smokescore=10 then smokescoremen=1;

  *Framingham Point Scores by HDL level;
  if sex="Male" &       hdl >= 60 then hdlscoremen=-1;
  if sex="Male" & 49 <= hdl <  60 then hdlscoremen=0;
  if sex="Male" & 40 <= hdl <  49 then hdlscoremen=1;
  if sex="Male" & .  <  hdl <  40 then hdlscoremen=2;

  *Creating sbp score;
  if bpmeds=0 and .   < sbp <= 120 then sbpscore=1;
  if bpmeds=0 and 120 < sbp <= 129 then sbpscore=2;
  if bpmeds=0 and 129 < sbp <= 139 then sbpscore=3;
  if bpmeds=0 and 139 < sbp <= 159 then sbpscore=4;
  if bpmeds=0 and       sbp >  159 then sbpscore=5;

  if bpmeds=1 and       sbp <= 120 then sbpscore=6;
  if bpmeds=1 and 120 < sbp <= 129 then sbpscore=7;
  if bpmeds=1 and 129 < sbp <= 139 then sbpscore=8;
  if bpmeds=1 and 139 < sbp <= 159 then sbpscore=9;
  if bpmeds=1 and       sbp >  159 then sbpscore=10;

  *Framingham Point Scores by systolic blood pressure and treatment status;
  if sex="Male" & sbpscore=1 then sbpscoremen=0;
  if sex="Male" & sbpscore=2 then sbpscoremen=0;
  if sex="Male" & sbpscore=3 then sbpscoremen=1;
  if sex="Male" & sbpscore=4 then sbpscoremen=1;
  if sex="Male" & sbpscore=5 then sbpscoremen=2;

  if sex="Male" & sbpscore=6 then sbpscoremen=0;
  if sex="Male" & sbpscore=7 then sbpscoremen=1;
  if sex="Male" & sbpscore=8 then sbpscoremen=2;
  if sex="Male" & sbpscore=9 then sbpscoremen=2;
  if sex="Male" & sbpscore=10 then sbpscoremen=3;

  *Sum of all categories to find out individual's Framingham Risk Score;
  F_male = sum(OF agescoremen cholscoremen smokescoremen hdlscoremen sbpscoremen);

  *10- Year risk by total Framingham Point Scores;
  if sex="Male" & . <  F_male <  0  then frs_atpiii_tenyrrisk = 0.01; *lablel <0.01;
  if sex="Male" & 0 <= F_male <= 4  then frs_atpiii_tenyrrisk = 0.01;
  if sex="Male" & 5 <= F_male <= 6  then frs_atpiii_tenyrrisk = 0.02;
  if sex="Male" &      F_male  = 7  then frs_atpiii_tenyrrisk = 0.03;
  if sex="Male" &      F_male  = 8  then frs_atpiii_tenyrrisk = 0.04;
  if sex="Male" &      F_male  = 9  then frs_atpiii_tenyrrisk = 0.05;
  if sex="Male" &      F_male  = 10 then frs_atpiii_tenyrrisk = 0.06;
  if sex="Male" &      F_male  = 11 then frs_atpiii_tenyrrisk = 0.08;
  if sex="Male" &      F_male  = 12 then frs_atpiii_tenyrrisk = 0.10;
  if sex="Male" &      F_male  = 13 then frs_atpiii_tenyrrisk = 0.12;
  if sex="Male" &      F_male  = 14 then frs_atpiii_tenyrrisk = 0.16;
  if sex="Male" &      F_male  = 15 then frs_atpiii_tenyrrisk = 0.20;
  if sex="Male" &      F_male  = 16 then frs_atpiii_tenyrrisk = 0.25;
  if sex="Male" &      F_male >= 17 then frs_atpiii_tenyrrisk = 0.30; *label >=0.30;

*For Females;

  *Framingham point scores by age group; 
  if sex="Female" & . < 20 < age <= 34 then agescorefe=-7;
  if sex="Female" &     34 < age <= 39 then agescorefe=-3;
  if sex="Female" &     39 < age <= 44 then agescorefe=0;
  if sex="Female" &     44 < age <= 49 then agescorefe=3;
  if sex="Female" &     49 < age <= 54 then agescorefe=6;
  if sex="Female" &     54 < age <= 59 then agescorefe=8;
  if sex="Female" &     59 < age <= 64 then agescorefe=10;
  if sex="Female" &     64 < age <= 69 then agescorefe=12;
  if sex="Female" &     69 < age <= 74 then agescorefe=14;
  if sex="Female" &     74 < age <= 79 then agescorefe=16;

  *Framingham cholesterol points based on gender and age; 
  if sex="Female" & cholscore=1 then cholscorefe=0;
  if sex="Female" & cholscore=2 then cholscorefe=4;
  if sex="Female" & cholscore=3 then cholscorefe=8;
  if sex="Female" & cholscore=4 then cholscorefe=11;
  if sex="Female" & cholscore=5 then cholscorefe=13;

  if sex="Female" & cholscore=6 then cholscorefe=0;
  if sex="Female" & cholscore=7 then cholscorefe=3;
  if sex="Female" & cholscore=8 then cholscorefe=6;
  if sex="Female" & cholscore=9 then cholscorefe=8;
  if sex="Female" & cholscore=10 then cholscorefe=10;

  if sex="Female" & cholscore=11 then cholscorefe=0;
  if sex="Female" & cholscore=12 then cholscorefe=2;
  if sex="Female" & cholscore=13 then cholscorefe=4;
  if sex="Female" & cholscore=14 then cholscorefe=5;
  if sex="Female" & cholscore=15 then cholscorefe=7;

  if sex="Female" & cholscore=16 then cholscorefe=0;
  if sex="Female" & cholscore=17 then cholscorefe=1;
  if sex="Female" & cholscore=18 then cholscorefe=2;
  if sex="Female" & cholscore=19 then cholscorefe=3;
  if sex="Female" & cholscore=20 then cholscorefe=4;

  if sex="Female" & cholscore=21 then cholscorefe=0;
  if sex="Female" & cholscore=22 then cholscorefe=1;
  if sex="Female" & cholscore=23 then cholscorefe=1;
  if sex="Female" & cholscore=24 then cholscorefe=2;
  if sex="Female" & cholscore=25 then cholscorefe=2; 

  *Framingham point scores by age and smoking status; 
  if sex="Female" & smokescore=1 then smokescorefe=0;
  if sex="Female" & smokescore=2 then smokescorefe=0;
  if sex="Female" & smokescore=3 then smokescorefe=0;
  if sex="Female" & smokescore=4 then smokescorefe=0;
  if sex="Female" & smokescore=5 then smokescorefe=0;

  if sex="Female" & smokescore=6 then smokescorefe=9;
  if sex="Female" & smokescore=7 then smokescorefe=7;
  if sex="Female" & smokescore=8 then smokescorefe=4;
  if sex="Female" & smokescore=9 then smokescorefe=2;
  if sex="Female" & smokescore=10 then smokescorefe=1;

  *Framingham point scores by HDL level;
  if sex="Female" &       hdl >= 60 then hdlscorefe=-1;
  if sex="Female" & 50 <= hdl <  60 then hdlscorefe=0;
  if sex="Female" & 40 <= hdl <  50 then hdlscorefe=1;
  if sex="Female" & .  <  hdl <  40 then hdlscorefe=2;

  *Framingham point scores by systolic blood pressure and treatment status; 
  if sex="Female" & sbpscore=1 then sbpscorefe=0;
  if sex="Female" & sbpscore=2 then sbpscorefe=1;
  if sex="Female" & sbpscore=3 then sbpscorefe=2;
  if sex="Female" & sbpscore=4 then sbpscorefe=3;
  if sex="Female" & sbpscore=5 then sbpscorefe=4;

  if sex="Female" & sbpscore=6 then sbpscorefe=0;
  if sex="Female" & sbpscore=7 then sbpscorefe=3;
  if sex="Female" & sbpscore=8 then sbpscorefe=4;
  if sex="Female" & sbpscore=9 then sbpscorefe=5;
  if sex="Female" & sbpscore=10 then sbpscorefe=6;

  *Sum of all categories to find out individual Framingham Risk Score;
  F_female = sum(OF agescorefe cholscorefe smokescorefe hdlscorefe sbpscorefe);

  *10-year risk by total Framingham point scores;
  if sex="Female" & .  <  F_female <  9  then frs_atpiii_tenyrrisk = 0.01; *Added label <0.01;
  if sex="Female" & 9  <= F_female <= 12 then frs_atpiii_tenyrrisk = 0.01;
  if sex="Female" & 13 <= F_female <= 14 then frs_atpiii_tenyrrisk = 0.02;
  if sex="Female" &       F_female  = 15 then frs_atpiii_tenyrrisk = 0.03;
  if sex="Female" &       F_female  = 16 then frs_atpiii_tenyrrisk = 0.04;
  if sex="Female" &       F_female  = 17 then frs_atpiii_tenyrrisk = 0.05;
  if sex="Female" &       F_female  = 18 then frs_atpiii_tenyrrisk = 0.06;
  if sex="Female" &       F_female  = 19 then frs_atpiii_tenyrrisk = 0.08;
  if sex="Female" &       F_female  = 20 then frs_atpiii_tenyrrisk = 0.11;
  if sex="Female" &       F_female  = 21 then frs_atpiii_tenyrrisk = 0.14;
  if sex="Female" &       F_female  = 22 then frs_atpiii_tenyrrisk = 0.17;
  if sex="Female" &       F_female  = 23 then frs_atpiii_tenyrrisk = 0.22;
  if sex="Female" &       F_female  = 24 then frs_atpiii_tenyrrisk = 0.27;
  if sex="Female" &       F_female >= 25 then frs_atpiii_tenyrrisk = 0.30; *Added label >=.30;
  format frs_atpiii_tenyrrisk frs_atpiii_tenyrrisk.;

*Only keep chd_atpiii variable;
data include3;
  set include3 (keep=subjid frs_atpiii_tenyrrisk);
run;


******** Reynolds Risk Score;

*Calling data sets needed for the creation of rrs;
data D; set analysis; run;
data E; set jhsv1.pfha; run; *data set containing fam history of heart disease variable;
 

*Sort data sets before merging;
proc sort data=D; by subjid; run;
proc sort data=E; by subjid visit; run;

*Merge the data sets; 
data include4;
  merge D (in=in1) E;
  by subjid;
  if in1=1;    *Only keep participants in visit2;
run;

*Create family history of heart disease variable;
*Note:
pfha21a is mother heart disease(Y/N), asked at visit1
pfha30a is father heart disease(Y/N), asked at visit1
pfhb28a is mother heart disease(1/2), asked at visit2 
pfhb37a is father heart disease(1/2), asked at visit2
;

*Create family history of heart disease;
data include4; set include4;
  if pfha21a="Y" | pfha30a="Y" /*| pfhb28a=1 | pfhb37a=1*/ then parhistheartdis=1; 
  else parhistheartdis=0;
run;

data include4; set include4;
*Only include participants within specified age range;
	if sex="Female" and age < 45 then delete;
	if sex="Male" and age >= 80 then delete;
*Only include participants who have all covariates;
	if missing(age) then delete;
	if missing(totchol) then delete;
	if missing(hdl) then delete;
	if missing(sbp) then delete;
	if missing(diabetes) then delete;
	if missing(eversmokerV1) then delete;
	if missing(sex) then delete;
    if missing(hsCRP) then delete;
    if missing(parhistheartdis) then delete;
	if sex="Female" and missing(HbA1c) then delete; *Only the formula for women has hba1c term;
run;
  
data include4; set include4;

*Male Covariates;

  *Iteraction terms;
  *conditional smoking term;
  if eversmokerV1=1 then smoketermen = 0.405;
  if eversmokerV1=0 then smoketermen = 0;

  *family history of premature myocardial infarction;
  if parhistheartdis= 1 then parhistheartdismen = 0.541;
  if parhistheartdis= 0 then parhistheartdismen = 0;

*Female Covariates;

  *Interaction terms;
  *conditional smoking term;
  if eversmokerV1=1 then smoketermwmn = 0.818;
  if eversmokerV1=0 then smoketermwmn = 0;

  *family history of premature myocardial infarction;
  if parhistheartdis= 1 then parhistheartdiswmn = 0.438;
  if parhistheartdis= 0 then parhistheartdiswmn = 0;

  *hemoglobin diabetes interaction term;
  if diabetes=1 then hemodiabtermwmn = 0.134 * HbA1c;
  if diabetes=0 then hemodiabtermwmn = 0;
run;

*Formulas for men and women;
data include4; set include4;

  logAge = .;
    if age ^= 0 & ^missing(age) then logAge = log(age);

  logSBP = .;
    if SBP ^= 0 & ^missing(SBP) then logSBP = log(SBP);

  logTotChol = .;
    if totChol ^= 0 & ^missing(totChol) then logTotChol = log(totChol);

  logHDL = .;
    if HDL ^= 0 & ^missing(HDL) then logHDL = log(HDL);

  logHScrp = .;
    if hsCRP ^= 0 & ^missing(hsCRP) then logHScrp = log(hsCRP);
  
    if sex="Male"  then do;

    *This is the B term for men;
    B_male= 4.385 * logAge + 2.607 * logSBP + 0.963 * logTotChol - 0.772 * logHDL + smoketermen 
			+0.102 * logHScrp + parhistheartdismen;
  end;
  else if sex="Female" then do;

    *This is the B term for women;
    B_female= 0.0799 * age + 3.137 * logSBP +  0.180 * logHScrp + 1.382 * logTotChol - 1.172 * logHDL 
                       + hemodiabtermwmn + smoketermwmn + parhistheartdiswmn;
  end;
run;

*10 year cardiovascular disease risk (%) for women;
data include4; 
  set include4;
  rrs_tenyrriskwmn=(1-(0.98634 **(EXP(B_female-22.325))));
run;

*10 year cardiovascular disease risk (%) for men;
data include4;
  set include4;		
  rrs_tenyrriskmen=(1-(0.8990 ** (EXP(B_male-33.097))));
run;

*Creating one variable for rrs ten year risk;
data include4;
  set include4;
  if sex="Male"   then rrs_tenyrrisk=rrs_tenyrriskmen;
  if sex="Female" then rrs_tenyrrisk=rrs_tenyrriskwmn;
run;

*Only keep rrs_tenyrrisk variable;
data include4;
  set include4 (keep=subjid rrs_tenyrrisk);
run;

*Round risk score;
data include4;
  set include4;
  rrs_tenyrrisk=round(rrs_tenyrrisk, .01);
run;
 

******10 Year Risk Estimate for Atherosclerotic Cardiovascular Disease using American Heart Association
      -American College of Cardiology Equations;

data include5; set analysis;
*Only include participants within the specified age range;
	if age < 40 | age > 79 then delete;
*Only include participants who have all covariates;
	if missing(age) then delete;
	if missing(totchol) then delete;
	if missing(hdl) then delete;
	if missing(sbp) then delete;
	if missing(diabetes) then delete;
	if missing(eversmokerV1) then delete;
	if missing(sex) then delete;
	if missing(bpmeds) then delete;

*Rename variables;
	smoke=eversmokerV1;
	dm=diabetes;
run;

data include5; set include5;

lnage    =log(age);
lntotchol=log(totchol);
lnhdl    =log(hdl);
lnsbp    =log(sbp);

*Formula for female with treated sbp;
if male=0 and bpmeds=1 then 
   xbeta = 17.114 * lnage + 0.940 * lntotchol - 18.920 * lnhdl + 4.475 * lnage * lnhdl +
					29.291 * lnsbp - 6.432 * lnage * lnsbp + 0.691 * smoke + 0.874 * dm ;

*Formula for female with untreated sbp;
if male=0 and bpmeds=0 then 
   xbeta = 17.114 * lnage + 0.940 * lntotchol - 18.920 * lnhdl + 4.475 * lnage * lnhdl +
					27.820 * lnsbp - 6.087 * lnage * lnsbp + 0.691 * smoke + 0.874 * dm ;

*Formula for male with treated sbp;
if male=1 and bpmeds=1 then 
   xbeta = 2.469 * lnage + 0.302 * lntotchol - 0.307 * lnhdl + 1.916 * lnsbp + 0.549 * smoke + 0.645 * dm ;

*Formula for male with untreated sbp;
if male=1 and bpmeds=0 then 
   xbeta = 2.469 * lnage + 0.302 * lntotchol - 0.307 * lnhdl + 1.809 * lnsbp + 0.549 * smoke + 0.645 * dm ;


*10 year ASCVD risk (%) for women;
if male=0 then
ascvd_tenyrrisk = 1- 0.9533**exp(xbeta- 86.61);

*10 year ASCVD risk (%) for women;
else if male=1 then
ascvd_tenyrrisk = 1- 0.8954**exp(xbeta- 19.54);
run;

*Only keep ascvd_tenyrrisk variable;
data include5;
  set include5 (keep=subjid ascvd_tenyrrisk);
run;

*Round risk score;
data include5;
  set include5;
  ascvd_tenyrrisk=round(ascvd_tenyrrisk, .01);
run;




/**************************** END **************************************/
*Merging all data sets with different risk scores;
data include; 		*combine 1, 2, 3, 4, 5;
  merge include1 include2 include3 include4 include5;
  by subjid;
run;

*Add to Analysis Dataset;
data analysis; *Add to Analysis Dataset;
  merge analysis(in = in1) include;
  by subjid;
  if in1 = 1; *Only keep clean ptcpts;
  run;

*Create keep macro variable for variables to retain in Analysis datasets (vs. analysis);
%let keep23riskscores= subjid frs_chdtenyrrisk frs_cvdtenyrrisk frs_atpiii_tenyrrisk rrs_tenyrrisk ascvd_tenyrrisk;
%put Section 23 Complete;




