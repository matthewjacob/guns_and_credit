*** ANALYSING GUN TRACE DATA

global raw "$personal_dropbox/Guns and Credit/data/raw"
global derived "$personal_dropbox/Guns and Credit/data/derived" 

*import trace data
import delimited using "$derived/state_firearms_laws", clear varnames(1)
ren ï* *

*clean data
keep if year == 2017
statastates, name(state) nogen
ren state_fips statefips

*make map
maptile lawtotal, geo(state) geoid(statefips) nq(10) fcolor(Greys2)
