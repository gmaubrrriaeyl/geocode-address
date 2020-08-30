###Police Shooting in Louisville
# 5 Jun 20

View(dat)
#Libraries
library(tidyverse)
library(readxl)
library(lubridate)
library(ggmap)
library(sf)
library(mapview)
library(googleAuthR)
setwd('C:/Users/gabee/Desktop/Police Shootings/Mapping Police Violence')

api_key <- # whoops I posted my api.. am dumb, please don't destroy my bank account
register_google(key = api_key, write = TRUE)

headers <- c('name','age', 'gender', 'race',	'victim_image', 'inc_date', 'inc_addr', 'city', 'state', 'zip', 'county', 'pd', 'cause', 'inc_desc', 'inc_disp', 'charged', 'news_url', 'mentalill', 'unarmed',	'weapon_wp', 'threat_wp',	'flee',	'camera_body', 'id_wp', 'offduty', 'popclass', 'id')
dat <- read_excel('dat.xlsx', col_names = headers) #reads, headers 
dat <- tail(dat, -1) #removes header row
dat$inc_date <- as.Date(as.numeric(dat$inc_date) , origin ="1899-12-30") # converts date
dat$inc_addr_full <- dat$inc_addr_full %>% paste0(dat$inc_addr, ', ', dat$city, ', ', dat$state, dat$zip, ', ', 'usa')

#Filtering to Louisville
lm <- dat %>% select(name, age, gender, race, inc_date, inc_addr, inc_addr_full, pd, cause, charged, unarmed
                     ) %>%
  filter(dat$city == "Louisville")

#Creating lat/long
geocoded <- data.frame(stringsAsFactors = FALSE)
for(i in 1:nrow(lm)) {
  result <- geocode(lm$inc_addr_full[i], output = "latlona", source = "google")
  lm$inc_lon[i] <- as.numeric(result[1])
  lm$inc_lat[i] <- as.numeric(result[2])
  lm$inc_geo[i] <- as.character(result[3])
} # https://www.storybench.org/geocode-csv-addresses-r/

map <- get_googlemap(center = c(38.25, -85.69), zoom = 10, )
