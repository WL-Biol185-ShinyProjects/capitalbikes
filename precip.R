
library(ggplot2)
library(tidyverse)




weather <- read.csv("mergedweatherdata.csv")

rain <- filter(weather, Preciptype == "rain")
  rainavg <- mean(rain$Duration)

noprecip <- filter(weather, is.na(Preciptype))
  noprecipavg <- mean(noprecip$Duration)

snow <- filter(weather, Preciptype == "rain,snow" | Preciptype == "snow")
  snowavg <- mean(snow$Duration)

freezingrain <- filter(weather, Preciptype == "freezingrain" | Preciptype == "rain,freezingrain")
  freezingrainavg <- mean(freezingrain$Duration)

 
data <- data.frame(
    preciptype=c("No Precipitation","Rain","Freezing Rain","Snow") ,  
    durationavg=c(noprecipavg,rainavg,freezingrainavg,snowavg)
  )

ggplot(data, aes(x = preciptype, y = durationavg)) +
  geom_bar(stat = "identity", fill = "red") +
  labs(title = "Average Ride Duration by Precipitation Type",
       x = "Type of Precipitation",
       y = "Average Ride Duration") +
  theme_minimal()



