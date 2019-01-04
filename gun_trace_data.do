*** ANALYSING GUN TRACE DATA

global raw "$personal_dropbox/Guns and Credit/data/raw"
global derived "$personal_dropbox/Guns and Credit/data/derived" 

*import trace data
import delimited using "$derived/gun_trace_data", clear varnames(1)
ren ï* *

*clean data
statastates, name(state) nogen
ren state_fips statefips
replace state = lower(state)
keep if !mi(statefips) | state == "total"
replace state = regexr(state, " ", "")
replace state = "districtofcolumbia" if state =="districtof columbia"
replace state = "usvirginislands" if state == "usvirgin islands"
gsort statefips

*get frac sourced from each state 
ds state total state*, not
gen prop_own_source =. 
local i = 1 
foreach var in `r(varlist)'{
	count if state == "`var'"
	if (`r(N)' > 0) {
	su `var' 
	replace prop_own_source = 100 * (`var' / `r(max)') in `i'
	local ++i
	}
}

*make map
maptile prop_own_source, geo(state) geoid(statefips) nq(10) fcolor(Greys2)
