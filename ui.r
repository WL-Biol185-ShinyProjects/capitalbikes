library(dplyr)
library(tidyverse)
library(shiny)

# import station names and coordinates
stations <- read.csv('bike_numbers.csv')

fluidPage(
  br(),
  selectInput("select_station_1",label = "Stations", choices = stations$name),
  br(),
  textOutput('select_station_1')
  
)