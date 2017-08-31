********************************************************************;
*********** 			Section 19: Nutrition  			 ***********;
********************************************************************;


title "Section 19: Nutrition ";

*Variable List;
  *Continuous;                    
 	 %let contvar = vitaminD2  vitaminD3 vitaminD3epimer darkgrnVeg eggs fish ;

  *No Categorical;                   
 	 
*Simple Data Listing & Summary Stats;
%simple;

*Validations********************************************************;

*Look at means and univariate distribution of transformed variabless;

/*
		proc means data=validanalysis1;*every variable in analysis 1 ds and subvariables;
			var &contvar;
		run;

		proc univariate data=validanalysis1 plots NOTABCONTENTS;
			 var &contvar;
		run;

		*Try log transformation of continuous variables due to right skewed distribution*;
		data validanalysis1;
			set validation;
			log_vitaminD2=log( vitaminD2);
			log_vitaminD3=log(vitaminD3);
			log_vitaminD3epimer=log(vitaminD3epimer);
		run;

		%let contvar =log_vitaminD log_vitaminD3epimer log_vitaminD3;

		proc univariate data=validanalysis1 noprint ;
			histogram &contvar;
		 run;
*/

%put Section 19 Complete;
