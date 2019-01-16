*** ANALYSING NRA DATA 

global raw "$personal_dropbox/Guns and Credit/data/raw"
global derived "$personal_dropbox/Guns and Credit/data/derived" 

*import trace data
import delimited using "$raw/fb_NRA_likes_by_county", clear varnames(1)
ren ï* *


gen frac_NRA = 100 * (nra_pop / pop) // frac of 20-60 y.o. FB pop 

*make map
maptile frac_NRA, geo(county1990) fcolor(Blues) conus stateoutline(thin)


* CORR NRA and Gun Sales and Mobility 
import delimited using "$raw/fb_NRA_likes_by_county", clear varnames(1)
ren ï* *
gen frac_NRA = 100 * (nra_pop / pop) // frac of 20-60 y.o. FB pop 

gen county_5_digit = string(county, "%05.0f")
drop county 
gen stfips = substr(county_5_digit,1,2)
destring stfips, replace 
collapse (mean) frac_NRA [w=pop], by(stfips)
tempfile nra
save `nra'

use "/Users/matthewjacob/Dropbox (Facebook)/Research files/outside/finer_geo/data/raw/census/data_for_paper/county_race_gender_early_dp.dta", clear
collapse (mean) kfr_pooled_pooled_p25 [w=kid_pooled_pooled_blw_p50_n], by(state)
ren state stfips
tempfile kfr
save `kfr'

*
use "$raw/science_paper/bckcheck-state-public.dta", clear
keep if year == 2015 
collapse (rawsum) total, by(stfips)
gen year = 2015
merge 1:1 stfips year using "$raw/science_paper/population-state-public", nogen keep(match)
merge 1:1 stfips using `nra', nogen 
merge 1:1 stfips using `kfr', nogen 


gen check_per_capita = total / pop
replace check_per_capita = 1000* check_per_capita

statastates, fips(stfips) nogen 
gen id =_n 

corr check_per_capita frac_NRA [w=pop]
local corr: di %04.2f `r(rho)'

tw ///
	(scatter check_per_capita frac_NRA if check_per_capita < 200) ///
	(scatter check_per_capita frac_NRA if check_per_capita < 200 & mod(id,3) ==0, msymb(none) mlab(state_abbrev) mlabcolor(gs8)), ///
	ytitle("Background Checks Per 1000 People in 2015") ///
	xtitle("Percent of 20-60 y.o. Who Like NRA on Facebook") ///
	text(20 4.5 "Corr: `corr'", color(gs8)) legend(off)
	
