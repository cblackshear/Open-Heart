********************************************************************;
******************** Define Analysis Data Formats ******************;
********************************************************************;

proc format library = analysis;
  *** Overall ***;
  value ynfmt
    0 = "No" 
    1 = "Yes";

  value pafmt
    0 = "Absent"
    1 = "Present";

	value tffmt
		0 = "False"
		1 = "True";

  value abnormal
    0 = "Normal"
    1 = "Abnormal";

  *** Section 1: Study-Level and Other-Items;
  value aric
    0 = "JHS-Only"
    1 = "Shared ARIC";

  value recruit
    1 = "Shared ARIC"
    2 = "ARIC Household"
    3 = "Random"
    4 = "Family"
    5 = "Volunteer";

  *** Section 2: Demographics ***;
  value male  
    0 = "Female"
    1 = "Male";
          
  value female 
    0 = "Male"
    1 = "Female";

  *** Section 3: Anthropometrics ***;
  value obesity3cat
  	0 = "Ideal Health"
  	1 = "Intermediate Health"
  	2 = "Poor Health";

  *** Section 4: Medications ***;
  value DMMedType
    0 = "No Diabetic Medications"
    1 = "Oral Only"
    2 = "Insulin Only"
    3 = "Both Oral and Insulin";

  value medAcct
    0 = "Incomplete recording of participant's medication use"
    1 = "Participant reported that no medication use"
    2 = "Complete recording of all participant's medication use";

  *** Section 5: Hypertension ***;
  value BPcat 
    0 = "Normal" 
    1 = "Pre-HTN" 
    2 = "Stage I HTN" 
    3 = "Stage II HTN"; 

  *** Section 6: Diabetics ***;
  value fpg3cat
    0 = "Normal"
    1 = "At Risk"
    2 = "Diabetic";

  value HbA1c3cat
    0 = "Normal"
    1 = "At Risk"
    2 = "Diabetic";

  value diab3cat 
    0 = "Non-Diabetic"
    1 = "Pre-Diabetic"
    2 = "Diabetic";

  *** Section 7: Lipids ***;
  value ldl5cat
    0 = "Optimal"
    1 = "Near/Above Optimal"
    2 = "Borderline High"
    3 = "High"
    4 = "Very High";
  
  value hdl3cat
    0 = "Low"
    1 = "Normal"
    2 = "High";

  value trigs4cat
    0 = "Normal"
    1 = "Borderline High"
    2 = "High"
    3 = "Very High";

  value totchol3cat
    0 = "Desirable (Normal)"
    1 = "Borderline High"
    2 = "High";

  *** Section 8: Biospecimens ***;

  *** Section 9: Renal ***;

  *** Section 10: Respiratory ***;
  value asthma 
    0 = "Never"
    1 = "Former"
    2 = "Current";

  *** Section 11: Echo ***;

  value geometry
    0 = "Normal Ventricle"
    1 = "Concentric Remodeling"
    2 = "Concentric Hypertrophy"
    3 = "Mixed Hypertrophy"
    4 = "Physiologic Hypertrophy"
    5 = "Eccentric Hypertrophy"
    6 = "Eccentric Remodeling"
    7 = "Unclassified";

  value EF3cat
    0 = "Normal"
    1 = "Preserved"
    2 = "Reduced";

  *** Section 12: ECG ***;

  *** Section 13: CT Imaging ***;

  *** Section 14: Stroke Self ***;

  *** Section 15: CVD Self ***;

  *** Section 16: Healthcare Access ***;
  value PrivPubl 
    0 = "Uninsured"
    1 = "Private Only"
    2 = "Public Only"
    3 = "Private & Public";

  value instype 
    0 = "Uninsured"
    1 = "Private Only"
    2 = "VA Only"
    3 = "Medicare Only"
    4 = "Medicaid Only"
    5 = "Private & VA"
    6 = "Private & Medicare"
    7 = "Private & Medicaid"
    8 = "VA & Medicare"
    9 = "VA & Medicaid"
   10 = "Medicare & Medicaid"
   11 = "Private & VA & Medicare"
   12 = "Private & VA & Medicaid"
   13 = "Private & Medicare & Medicaid"
   14 = "VA & Medicare & Medicaid"
   15 = "Private & VA & Medicare & Medicaid";
  
  value publinstyp
    1 = "Medicaid Only"
    2 = "Medicare Only"
    3 = "Medicare & Medicaid";

  *** Section 17: Sociocultural ***;
  value $fmlyinc
    'A' = "Less than $5,000"
    'B' = "$5,000 - 7,999"
    'C' = "$8,000 - 11,999"
    'D' = "$12,000 - 15,999"
    'E' = "$16,000 - 19,999"
    'F' = "$20,000 - 24,999"
    'G' = "$25,000 - 34,999"
    'H' = "$35,000 - 49,999"
    'I' = "$50,000 - 74,999"
    'J' = "$75,000 - 99,999"
    'K' = "$100,000 or more";

  value inc
    1 = "Poor"
    2 = "Lower-middle"
    3 = "Upper-middle"
    4 = "Affluent";
      
  value Occup
    1 = "Management/Professional"
    2 = "Service"
    3 = "Sales"
    4 = "Farming"
    5 = "Construction"
    6 = "Production"
    7 = "Military"
    8 = "Sick"
    9 = "Unemployed"
    10 = "Homemaker"
    11 = "Retired"
    12 = "Student"
    13 = "Other";

  value edu
    1 = "Less than high school"
    2 = "High school graduate"
    3 = "GED"
    4 = "Some vocational or trade school, but no certificates"
    5 = "Vocational or trade certificate "
    6 = "Some college, but no degree "
    7 = "Associate degree"
    8 = "Bachelor’s degree"
    9 = "Graduate or professional schools";

  value edu3cat
	0 = "Less than high school"
	1 = "High school graduate/GED"
	2 = "Attended vocational school, trade school, or college" ;

value stsa
    1 = "Not Stressful"
    2 = "Mildly Stressful"
    3 = "Moderately Stresful"
    4 = "Very Stressful";

value soca
	1 = "None"
    2 = "1 or 2"
    3 = "3 to 5"
    4 = "6 to 9"
		5 = "10 or more";

  value discrim
    1 = "Speak up"
    2 = "Accept it"
    3 = "Ignore it"
    4 = "Try to change it"
    5 = "Keep it to yourself"
    6 = "Work harder to prove them wrong"
    7 = "Pray"
    8 = "Avoid it"
    9 = "Get violent"
    10 = "Forget it"
    11 = "Blame yourself"
    12 = "Other";

  value disaTWO
    1 = "Your age"
    2 = "Your gender"
    3 = "Your race"
    4 = "Your height or weight"
    5 = "Some other reason for discrimination";

  value rcpa
    1 = "Strongly Agree"
    2 = "Agree Somewhat"
    3 = "Disagree Somewhat"
    4 = "Strongly Disagree";

  value rcpaTWO
    1 = "Never"
    2 = "Once in a while"
    3 = "Some days"
    4 = "Most days"
    5 = "Every day"
    6 = "Many times a day";

  value cesa
    1 = "Rarely or None of the time (Less than 1 day)"
    2 = "Some or Little of the time (1-2 days)"
    3 = "Occasionally or a Moderate Amount of the Time (3-4 days)"
    4 = "Most or All of the Time (5-7 days)";

  value wsia
    0 = "Did Not Happen"
    1 = "Not Stressful"
    2 = "Slightly Stressful"
    3 = "Mildly Stressful"
    4 = "Moderately Stressful"
    5 = "Stressful"
    6 = "Very Stressful"
    7 = "Extremely Stressful";

  value anger
    1 = "Almost Never"
    2 = "Sometimes"
    3 = "Often"
    4 = "Almost Always";

  value csia
    1 = "Never"
    2 = "Seldom"
    3 = "Sometimes"
    4 = "Often"
    5 = "Almost Always";

  *** Section 18: Life's Simple 7 ***;
  value activity
    1	 = "aerobic dance"
    2  = "bicycling"
    3	 = "crew/rowing machine"
    4	 = "cross country skiing or ski machine"
    5	 = "hiking/back packing"
    6	 = "running/jogging"
    7	 = "stairclimber"
    8	 = "stationary bike"
    9	 = "swimming"
    10 = "treadmill"
    11 = "vigorous walking"
    12 = "calisthenics"
    13 = "circuit training"
    14 = "nautilus"
    15 = "stretching/yoga"
    16 = "weight lifting"
    17 = "badminton"
    18 = "racquetball"
    19 = "tennis"
    20 = "canoeing/kayaking"
    21 = "diving"
    22 = "sailing"
    23 = "waterskiing"
    24 = "windsurfing/bodysurfing"
    25 = "African, Haitian dance"
    26 = "ballet (modern or jazz)"
    27 = "folk or social dance"
    28 = "other dance"
    29 = "basketball"
    30 = "field hockey/lacrosse"
    31 = "soccer"
    32 = "softball"
    33 = "volleyball"
    34 = "bowling"
    35 = "golf"
    36 = "gymnastics"
    37 = "horseback riding"
    38 = "martial arts"
    39 = "ice skating"
    40 = "downhill skiing"
    41 = "walking"
    42 = "water aerobics"
    43 = "officiating sports"
    44 = "sit to be fit & chair class"
    45 = "home aerobic machine"
    46 = "hunting"
    47 = "stretching around house"
    48 = "baseball"
    49 = "ping pong (table tennis)"
    50 = "sit ups"
    51 = "fishing"
    52 = "taebo"
    53 = "physical therapy"
    54 = "coaching sports"
    55 = "climb bleachers"
    56 = "push ups"
    57 = "hot air ballooning"
    58 = "ab machine (slider)"
    59 = "Gazell elliptical machine"
    60 = "total gym"
    61 = "kick boxing"
    62 = "football"
    63 = "cardio training"
    64 = "leg pressor"
    65 = "spinning"
    66 = "glider"
    67 = "step aerobics"
    68 = "low impact aerobics"
    69 = "arm and/or leg exercise"
    70 = "flag football"
    71 = "drumming"
    72 = "pilates"
    73 = "therapeutic exercise ball, Fitball exercise"
    74 = "activity promoting video game, light effort"
    75 = "activity promoting video game, moderate effort"
    76 = "Curves exercise routines in women"
    77 = "health club exercise, general"
    78 = "bicycling, stationary, general"
    79 = "basketball, non-game, general"
    80 = "zumba";

  value LSS3cat
    0 = "Poor Health"
    1 = "Intermediate Health"
    2 = "Ideal Health";

  *** Section 21: Life's Simple 7 ***;
  value rs334fm 
    2 = "AA: Minor-Minor (SCDisease)"  
    1 = "AT: Heterogeneous (SCTrait)"  
    0 = "TT: Major-Major";

  value sicklecellfm  
    1 = "AT: (SCTrait) or AA (SCDiseaese)"  
    0 = "TT: Major-Major";

  value APOL1G1fm 
    0 = "Non G1 risk allele (AATT)"
    1 = "Atypical G1 risk allele (1 replacement: AAGG / AAGT / GGTT / GATT)"
    2 = "G1 risk allele (2 replacements: GGGG / GAGG / GGTG / GAGT)";

  value APOL1G2fm  
    0 = 'Zero G2 risk alleles (RR)' 
    1 = 'One G2 risk allele (RD)'
    2 = 'Two G2 risk alleles (DD)';

  value apol1riskfm 
    0 = 'Zero risk alleles'
    1 = 'One risk allele'
    2 = 'Two  risk alleles';
 
 value rs13339636fm 
   2     = "GG: Minor-Minor"
   1     = "AG: Heterogeneous" 
	 0     = "AA: Major-Major"
	 .     = " "  
   other = "Imputed";

 run;
