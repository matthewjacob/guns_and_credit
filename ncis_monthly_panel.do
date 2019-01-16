*** ANALYSING NCIS STATE-BY-MONTH DATA

global raw "$personal_dropbox/Guns and Credit/data/raw"
global derived "$personal_dropbox/Guns and Credit/data/derived" 

*import trace data
use "$raw/science_paper/bckcheck-state-public", clear 
merge m:1 year stfips using "$raw/science_paper/population-state-public", nogen 
e

*First, create sales figures *;
******************************;
use bckcheck-state-public.dta;

keep if year>=2008

collapse (sum) total, by(year month)

gen sandyhookp1 = year == 2012 & month == 12
gen sandyhookp2 = year == 2013 & month == 1
gen sandyhookp3 = year == 2013 & month == 2
gen sandyhookp4 = year == 2013 & month == 3
gen sandyhookp5 = year == 2013 & month == 4

tab month, gen(monthdv)

forvalues y = 2009/2015 {
  gen yrdv`y' = year == `y'
}

*Estimate de-seasonalized and de-trended gun sales;
regress total sandyhookp1-sandyhookp5 monthdv2-monthdv12 yrdv2009-yrdv2015
predict resid, resid

format total %10.0f;
*These residuals are the points for the times series in Figure 2.;
*The points for the Sandy Hook time period are the residuals + the coefficients on sandyhookp1-sandyhookp5.;
list year month total resid, clean
clear;

* Sandy Hook Analysis 
keep if stname == "CT" & year >= 2012 

*graph
gen totalpc = (total/pop)*100000
gen xaxis = _n

tw /// 
	(connected totalpc xaxis)


