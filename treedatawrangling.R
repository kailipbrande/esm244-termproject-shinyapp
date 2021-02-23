

library(tidyverse)
library(lubridate)
library(readr)
library(sf)
library(stringr)
library(janitor)
library(here)


tree_data <- read_csv("treedat_1220.csv")


# just getting the columns we need

tree_data_app <- tree_data %>%
  select(FID, species, TAG0305, jan38, oct43, jun54, may67, jan80, may94, jul04, aug12,
         jul14, jun16, jul18, aug20, POINT_X, POINT_Y, usecode) %>%
  filter(usecode %in% 1)


# Frank said "usecode -  0 = not appropriate for analysis, 1=appropriate for
# analysis, 2 = appropriate for analysis but may be on atypical site or I was
# less confident in species identify, 3 = not appropriate for analysis" so I
# filter for only where the usecode is 1


# convert dates columns to useful year format (since only the year will be on our slider bar)

tree_data_app <- tree_data_app %>%
  rename("1938" = "jan38") %>%
  rename("1943" = "oct43") %>%
  rename("1954" = "jun54") %>%
  rename("1967" = "may67") %>%
  rename("1980" = "jan80") %>%
  rename("1994" = "may94") %>%
  rename("2004" = "jul04") %>%
  rename("2012" = "aug12") %>%
  rename("2014" = "jul14") %>%
  rename("2016" = "jun16") %>%
  rename("2018" = "jul18") %>%
  rename("2020" = "aug20")

# need to remove NA's from the ends of the POINT X and Y values

tree_data_app$POINT_X <- stringr::str_replace(tree_data_app$POINT_X, 'NA9', '')
tree_data_app$POINT_X <- stringr::str_replace(tree_data_app$POINT_X, 'NA', '')

tree_data_app$POINT_Y <- stringr::str_replace(tree_data_app$POINT_Y, 'NA9', '')
tree_data_app$POINT_Y <- stringr::str_replace(tree_data_app$POINT_Y, 'NA', '')

tree_data_app <- tree_data_app %>%
  drop_na()

#need to convert point x and y to numeric values to then be able to convert to coordinates
options(digits = 11) # this is so converting to a numeric value keeps the post-decimal value
tree_data_app$POINT_X <- as.numeric(tree_data_app$POINT_X)

tree_data_app$POINT_Y <- as.numeric(tree_data_app$POINT_Y)


# also convert lat and long columns to spatial coordinates
tree_spatial <- st_as_sf(tree_data_app, coords = c("POINT_X", "POINT_Y"), crs = 4326)

# reading in CA counties data from lab 6
ca_counties <- read_sf(here("Sedgwick_Oaks", "ca_counties"), layer = "CA_Counties_TIGER2016") %>%
  clean_names() %>%
  select(name)

# transform ca_counties to 4326 so its the same as tree_spatial
ca_counties <- st_transform(ca_counties, st_crs(tree_spatial)) # transformed
st_crs(ca_counties) # now its "EPSG", 4326

#lets just isolate for SB county since that's where Sedwick is
sb_county <- ca_counties %>%
  filter(name == "Santa Barbara")

sb_depth <- tree_spatial %>%
  st_intersection(sb_county)

# plot to take a look
ggplot() +
  geom_sf(data = sb_county) +
  geom_sf(data = tree_spatial, aes(color = species))

