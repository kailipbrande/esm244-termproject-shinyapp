library(tidyverse)
library(lubridate)
library(readr)
library(sf)
library(stringr)


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

tree_data_app$POINT_Y <- stringr::str_replace(tree_data_app$POINT_X, 'NA9', '')
tree_data_app$POINT_Y <- stringr::str_replace(tree_data_app$POINT_X, 'NA', '')

tree_data_app <- tree_data_app %>%
  drop_na()

tree_data_app <- tree_data_app %>%
  mutate(POINT_X = as.numeric(POINT_X), POINT_Y = as.numeric(POINT_Y))

# also convert lat and long columns to spatial coordinates

tree_spatial <- st_as_sf(tree_data_app, coords = c("POINT_X", "POINT_Y"), crs = 4326)
