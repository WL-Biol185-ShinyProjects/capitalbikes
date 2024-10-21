library(sf)

data = read.csv("2023-station-coordinates.csv", as.is=T)

points = st_as_sf(data, coords = c("LONGITUDE", "LATITUDE"), crs = 4326)

plot(st_geometry(points), pch=16, col="red")

