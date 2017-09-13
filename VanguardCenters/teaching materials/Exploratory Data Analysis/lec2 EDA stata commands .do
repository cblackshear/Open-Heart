** lecture 2: EDA code

*turn off the need to hit the space bar
set more off, permanently

** change to project directory
****************************************************
* YOU MUST CHANGE THIS TO YOUR DIRECTORY STRUCTURE!:
****************************************************;
* Example: cd "C:\JHS\VanguardCenters\teaching materials\EDA";
cd "C:\...\VanguardCenters\teaching materials\EDA";

*read data in
use "1-data\dat.dta", clear

*example of generating new values
generate smoker=(currsmoke==2) //Note the double == sign for comparisons
label variable smoker "Current Smoker"

*examples of labeling values:
*step 1) define label
*step 2) attach label
label define gender 0 "Female" 1 "Male"
label values male gender

label define smoke 0 "Non-Smoker" 1 "Smoker"
label values smoker smoke

label define diab 0 "Non-Diab" 1 "Diabetic"
label values diabetes diab

 
 
*look at data (first 10 obs)
*list id-glucose in 1/10
list id hdl age in 1/10

*simple 1-way tables of categorical variables
tab1  bmigp diabetes educ chd alcohol currsmoke smoker male

*simple summaries of continuous variables
summarize age bmi glucose hdl ldl tg egfr systolic diastolic 

*simple histograms
histogram hdl
histogram age
histogram tg
 
** nicer histograms
*-HDL-
*get details
summarize hdl, detail
return list
*store details as temporary plotting vars
gen _mn = r(mean) in 1/2
gen _p25 = r(p25) in 1/2
gen _p50 = r(p50) in 1/2
gen _p75 = r(p75) in 1/2
gen _y = 0 in 1
replace _y = 0.04 in 2
*cooler hist with (lots of) options
histogram hdl, ///
	normal normopts(lcolor(cranberry) lwidth(thick)) ///
	kdensity kdenopts(lwidth(thick) lpattern(dash)) ///
	addplot( 		 								///
	  (line _y _p25, lcolor(dkgreen) lpattern(dash))	///
	  (line _y _p75, lcolor(dkgreen) lpattern(dash))	///
	  (line _y _p50 									///
	    , lcolor(dkgreen) lpattern(dash) lwidth(thick)) ///
	  (line _y _mn, lcolor(cranberry) lwidth(thick))) ///
	ytitle(, size(huge)) ylabel(, labsize(vlarge)) 	///
	xtitle(HDL) xtitle(, size(huge)) 				///
	xlabel(, labsize(vlarge)) legend(off)
drop _* // remove temporary plotting vars

*-AGE-
*get details
summarize age, detail
*store details as temporary plotting vars
gen _mn = r(mean) in 1/2
gen _p25 = r(p25) in 1/2
gen _p50 = r(p50) in 1/2
gen _p75 = r(p75) in 1/2
gen _y = 0 in 1
replace _y = 0.045 in 2
*cooler hist with (lots of) options
histogram age, ///
	normal normopts(lcolor(cranberry) lwidth(thick)) ///
	kdensity kdenopts(lwidth(thick) lpattern(dash)) ///
	addplot( 		 								///
	  (line _y _p25, lcolor(dkgreen) lpattern(dash))	///
	  (line _y _p75, lcolor(dkgreen) lpattern(dash))	///
	  (line _y _p50 									///
	    , lcolor(dkgreen) lpattern(dash) lwidth(thick)) ///
	  (line _y _mn, lcolor(cranberry) lwidth(thick))) ///
	ytitle(, size(huge)) ylabel(, labsize(vlarge)) 	///
	xtitle(AGE) xtitle(, size(huge)) 				///
	xlabel(, labsize(vlarge)) legend(off)
drop _* // remove temporary plotting vars

*find normal approx range for expected 95% of data
display 53.6-2*10.7	// 32.2
display 53.6+2*10.7	// 75

*-TG-
summarize tg, detail
histogram tg, normal kdensity
*create new variable: log of triglycerides
generate logtg = log(tg)
histogram logtg, normal kdensity

** simple scatterplot of HDL vs Age
twoway (scatter hdl age)
** better scatterplot of HDL vs Age with options
twoway (lfitci hdl age, clcolor(navy)) ///
	(lowess hdl age, lcolor(cranberry) ///
		lwidth(medthick) lpattern(dash)) ///
	(scatter hdl age, mcolor(navy) msize(vsmall))	///
	, ytitle(HDL) ytitle(, size(huge)) ///
	ylabel(, labsize(vlarge)) xtitle(AGE) ///
	xtitle(, size(huge)) xlabel(, labsize(vlarge)) ///
	legend(off)

** by gender
twoway (lfitci hdl age, clcolor(navy)) ///
	(lowess hdl age, lcolor(cranberry) ///
		lwidth(medthick) lpattern(dash)) ///
	(scatter hdl age, mcolor(navy) msize(small))	///
	, ytitle(HDL) ytitle(, size(huge)) ///
	ylabel(, labsize(vlarge)) xtitle(AGE) ///
	xtitle(, size(huge)) xlabel(, labsize(vlarge)) ///
	by(male) by(, legend(off)) subtitle(, size(huge))


	
* Boxplots
*HDL
graph box hdl ///
  , over(male) over(diabetes) over(smoker) ///
  ytitle("HDL", size(large)) ylabel(, labsize(large))
  
*Trigs
graph box tg ///
  , over(male) over(diabetes) over(smoker) ///
  ytitle("TG", size(large)) ylabel(, labsize(large))

*log(Trigs)
graph box logtg ///
  , over(male) over(diabetes) over(smoker) ///
  ytitle("log(TG)", size(large)) ylabel(, labsize(large))



	