*** ANALYSING GUN TRACE DATA

global raw "$personal_dropbox/Guns and Credit/data/raw"
global derived "$personal_dropbox/Guns and Credit/data/derived" 

*import trace data
import delimited using "$raw/fb_NRA_likes_by_county", clear varnames(1)
ren ï* *


gen frac_NRA = 100 * (nra_pop / pop) // frac of 20-60 y.o. FB pop 

*make map
maptile frac_NRA, geo(county1990) fcolor(Blues) conus stateoutline(thin)
