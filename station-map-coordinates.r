# for loading our data
library(readr)
# for plotting
library(leaflet)


stations <- read.csv("2023-station-coordinates.csv")

leaflet(data = stations) %>%
  addTiles() %>%
  addMarkers(popup = ~NAME, lng = ~LONGITUDE, lat = ~LATITUDE)

leaflet()