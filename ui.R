library(shiny)
library(bslib)
library(markdown)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)
library(leaflet)
library(mapsapi)
library(gmapsdistance)
library(elevatr)

# Define UI

stations <- read.csv("bike_numbers.csv")

ui = navbarPage("Capital Bikes",
                theme = bs_theme(bootswatch = "united"),
                tabPanel("About",
                         
                          
                           mainPanel(
                             img(src = "CapitalBikeshareStationDockedBikes.jpg", height="100%", width="100%", align = "left"),
                             h3("About Our Capital Bikes App"),
                             p("This Shiny app is designed to help users find bike stations, plan routes between stations, analyze how weather trends impact bike usage, and identify the most popular stations used by city bikers each month. Use the tabs to navigate between features and customize plots using the available controls."),
                             p("The Bike Station Map tab allows you to find your desired station as well as the number of available bikes at each station. The Bike Router tab creates routes between any two stations. The Weather Trends tab allows you to explore data using interactive sliders, and the Station Frequency tab 
         gives information of the top 10 most started from stations every month and things to do at those stations. Our data is from the year 2023."),
                             p("This data was taken from the Kaggle data set 'Capital bike share dataset 2020/05 ~ 2024/ 08' found at https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408."),
                             p("This app was designed by Daniel Lu, Ava GianGrasso, and Hatcher Cook at Washington and Lee University. Daniel and Ava are junior neuroscience majors, and Hatcher is a senior biology major."),
                           )
                         
                ),
           tabPanel("Bike Station Map",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput(
                          "name", 
                          label = h3("Origin Station"),
                          choices = stations$name,
                        )
                      ),
                        mainPanel(
                          h3("Interactive Bike Station Map"),
                          p("Use this dropdown selecter to locate the station of your choosing. The table informs how many normal bikes, e-bikes, and total of normal and e-bikes avalible at every station. The larger green dots signify stations with more bikes, and the smaller red dots signify stations with less bikes."),
                         tableOutput("stationTable"),
                         leafletOutput("stationMap")
                      )
                    )
           ),
           
           tabPanel("Bike Router",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput("origin", "Origin", choices = c("Select a station" = "", sort(stations$name))),
                        selectInput("destination", "Destination", choices = c("Select a station" = "", sort(stations$name))),
                        actionButton("route", "Plan Route"),
                        hr(),
                      ),
                      mainPanel(
                        h3("Interactive Bike Router Map"),
                        p("Are you trying to get from one place to another but don’t know the way? Do you want to ride to a suggested station based on the fun station descriptions in our ‘Station Frequency’ tab? Just input where you’re starting from and where you want to go, and follow the path our Bike Router plans for you, complete with elevation details."),
                        leafletOutput("map")
                      )
                    )
           ),
           
              tabPanel("Weather Trends",
                        sidebarLayout(
                            sidebarPanel(
                              radioButtons("plotType", "Date vs Ride Duration Plot type",
                                           c("Scatter"="p", "Bar Graph"="b")
                                ),
                              sliderInput(
                                inputId = "date_slider",
                                label = "Filter by Date Range:",
                                min = as.Date("2023-01-01"),  
                                max = as.Date("2023-12-31"),  
                                value = c(as.Date("2023-01-01"), as.Date("2023-12-31")),  
                                timeFormat = "%Y-%m-%d"
                              ),
                              sliderInput(
                                inputId = "temp_slider",
                                label = "Filter by Temperature Range:",
                                min = 32, 
                                max = 90,   
                                value = c(32, 90)  
                            )
                              ),
                              mainPanel(
                                h3("Weather Trend Interactive Plots"),
                                p("Have you ever wondered when the Captial Bike system was most used? Or how the weather and temperature impact how long people bike for? Explore our plots to gain insight into when DCers use this bike service the most."),
                                plotlyOutput("dateduration"),
                                plotlyOutput("tempduration"),
                                plotOutput("precipduration")
                              )
                            )
           ),
           
tags$style(HTML("
    #stationBlurb {
      white-space: pre-wrap; 
      word-wrap: break-word;
      overflow: visible;
      height: auto; 
      max-height: none;
    }
  ")),
               tabPanel("Station Frequency",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(inputId = "selectMonth", 
                                        label = h3("Select Month"),
                                        choices = c("January", "February", "March", "April", 
                                                    "May", "June", "July", "August", "September", "October", "November", "December"),
                                        selected = "January"),
                            textInput(
                              inputId = "stationName", 
                              label = h3("Enter Station Name"),
                              placeholder = "Type a station name here..."
                            ),
                            h3("Station Details:"),
                            verbatimTextOutput("stationBlurb"),
                          ),
                          mainPanel(
                            h3("Start Station Frequency"),
                            p("This tab allows you to compare the top 10 most frequented start stations customers used each month. This is meant to help new bike users understand which stations are popular throughout the city. You'll find that Union Station was the most popular station to start biking from, with it being used the most frequently 11 out of 12 months of the year in 2023. Watch as the values get higher throughout the middle of the year, reaching a high of 5,340 starts from Union Station in October, 2023. If you're looking for reccomended activities and destinations for a specific station, just type in the station of your choosing and read up."),
                            plotlyOutput("selectedfreq", height="800px"),
                          )
                        )
           ),

 )


