## Shotspotter Analysis 
setwd("/Users/matthewjacob/Dropbox (Facebook)/Personal/Projects/Guns and Credit/data/raw/shotspotter")

#import packages 
library(tidyverse)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

#import data
df = read.csv("peoria_il_sst.csv")

#tidy
df$year = format(as.Date(df$Date, format="%m/%d/%y"),"%Y")
df_2018 = df[which(df$year == 2018),]

#maps 
states <- map_data("state")
illinois <- subset(states, region %in% c("illinois"))

ggplot(data = illinois) + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "palegreen", color = "black") + 
  geom_point(data = df_2018, aes(x = Longitude, y = Latitude, fill = "red", alpha = 0.8), size = 1, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE) + 
  coord_fixed(xlim = c(-90, -89),  ylim = c(40.6, 40.8), ratio = 3)
