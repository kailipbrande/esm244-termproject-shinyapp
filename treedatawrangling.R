
# =======
library(tidyverse)
library(lubridate)
library(readr)
library(sp)
library(sf)
library(stringr)
library(janitor)
library(here)
library(rgdal)


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

tree_data_app <- tree_data_app %>%
  drop_na()

# with help from this stackoverflow forum (https://stackoverflow.com/questions/52508902/convert-utm-to-lat-long-or-vice-versa), I realzied I have to convert the lat long to utm following this order
tree_spatial = SpatialPoints(cbind(tree_data_app$POINT_X, tree_data_app$POINT_Y), proj4string=CRS("+proj=utm +zone=10 +datum=WGS84"))

# then converting it to an sp and data frame
tree_spatial_transform = spTransform(tree_spatial, CRS("+proj=longlat +datum=WGS84")) %>%  as.data.frame()

# then cbinding it to the original tree_data_app and removing our old "PointX" & "Point Y" and renaming our new UTM coordinates
tree_spatial_latlong<- cbind(tree_data_app,tree_spatial_transform) %>%
  rename(lat = coords.x1, long = coords.x2) %>%
  select(-POINT_X, -POINT_Y)

## converting the lat long to crs 4326
tree_spatial_cord <- st_as_sf(tree_spatial_latlong, coords = c("lat", "long"), crs = 4326)


# reading in CA counties data from lab 6
ca_counties <- read_sf(here("Sedgwick_Oaks", "ca_counties"), layer = "CA_Counties_TIGER2016") %>%
  clean_names() %>%
  select(name)

# transform ca_counties to 4326 so its the same as tree_spatial_cord
ca_counties <- st_transform(ca_counties, st_crs(tree_spatial_cord)) # transformed
#st_crs(ca_counties) # now its "EPSG", 4326

#lets just isolate for SB county since that's where Sedgwick is
sb_county <- ca_counties %>%
  filter(name == "Santa Barbara")

sb_depth <- tree_spatial_cord %>%
  st_intersection(sb_county)

# plot to take a look
ggplot() +
  geom_sf(data = sb_county) +
  geom_sf(data = tree_spatial_cord, aes(color = TAG0305))


## Map of Sedgwick in California
a <- c(-120.040650)
b <- c(34.692710)
lat_long_sedgwick <- data.frame(a,b) %>%
  rename(lat = a, long = b) %>%
  mutate(lat = as.numeric(lat),
         long = as.numeric(long)) %>%
  st_as_sf(coords = c("lat", "long"), crs = 4326) %>%
  mutate(Site = c("Sedgwick"))

ca_counties <- st_transform(ca_counties, st_crs(lat_long_sedgwick))

## Sedgwick's location in the state
ggplot() +
  geom_sf(data = ca_counties) +
  geom_sf(data = lat_long_sedgwick, aes(color = Site), size = 3) +
  theme_minimal()

## ## Sedgwick's location in the county
ggplot() +
  geom_sf(data = sb_county) +
  geom_sf(data = lat_long_sedgwick, aes(color = Site), size = 3) +
  theme_minimal()



# Making updated data frame that contains only 1's (alive) or 0's (dead) for each tree for each year

tree_spatial_cord_updated <- tree_spatial_cord %>%
  mutate("1938correct" = case_when("1938" == "1" | "1938" == "2" ~ 1,
                                   TRUE ~ 0
  ))



# Making function that selects only trees that are 1's (not 0's)

# make df that only have the year columns
tree_spatial_cord_updated_years <- tree_spatial_cord_updated %>%
  select("1938", "1943", "1954", "1967", "1980", "1994", "2004", "2012", "2014" ,"2016", "2018", "2020")

is_alive <- function(data, x) {
  y <- ifelse(x == 1, 1, NA)
  y <- drop_na(y)
  return(y)
}

# testing it

is_alive(data = tree_spatial_cord_updated_years, x = tree_spatial_cord_updated_years[])
>>>>>>> origin
