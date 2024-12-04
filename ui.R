library(shiny)
library(bslib)
library(markdown)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)
library(leaflet)
library(mapsapi)

# Define UI

stations <- read.csv("bike_numbers.csv")

ui = navbarPage("Capital Bikes",
                theme = bs_theme(bootswatch = "united"),
                tabPanel("About",
                         
                          
                           mainPanel(
                             h3("About Our Capital Bikes App"),
                             p("This Shiny app is designed to help users find bike stations, view how weather trends impact bike usage, and see the most popular stations city bikers use each month. 
         Use the tabs to navigate between features, and customize plots using the controls."),
                             p("The Bike Station Map tab allows you to find your desired station as well as the number of bike docks. The Weather Trends tab allows you to explore data using interactive sliders, and the Station Frequency tab 
         gives information of the top 10 most started from stations every month. Our data is from the year 2023"),
                             plotOutput("plot900")
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

# 
#                         hr(),
#                         fluidRow(column(3, verbatimTextOutput("value")))
# 
# 
#                         ),
                        mainPanel(
                          h3("Interactive Bike Station Map"),
                          p("Use this dropdown selecter to locate the station of your choosing. The larger green dots signify stations with more bikes, and the smaller red dots signify stations with less bikes."),
                         tableOutput("stationTable"),
                         leafletOutput("stationMap")
                      )
                    )
           ),
              tabPanel("Weather Trends",
                        sidebarLayout(
                            sidebarPanel(
                              radioButtons("plotType", "Plot type",
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
             tabPanel("Bike Router",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput("select3", label = h3("Select box"),
                                       choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                       selected = 1),

                           hr(),


                         ),
                         mainPanel(
                           plotOutput("plot100")
                         )
                       )
           ),
tags$style(HTML("
    #stationBlurb {
      white-space: pre-wrap; /* Allows for multiline text */
      word-wrap: break-word; /* Ensures long words break appropriately */
      overflow: visible; /* Ensures the box does not scroll */
      height: auto; /* Height adjusts based on the content */
      max-height: none; /* Ensure there is no maximum height */
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
                            h3("Station Details"),
                            verbatimTextOutput("stationBlurb"),
                          ),
                          mainPanel(
                            h3("Start Station Frequency"),
                            p("This tab allows you to compare the top 10 most frequented start stations customers used each month. This is meant to help new bike users understand which stations are popular throughout the city. You'll find that Union Station was the most popular station to start biking from, with it being used the most frequently 11 out of 12 months of the year in 2023. Watch as the values get higher throughout the middle of the year, reaching a high of 5,340 starts from Union Station in October, 2023."),
                            plotlyOutput("selectedfreq", height="800px"),
                          )
                        )
           ),
               # tabPanel("Bike Router",
               #          # titlePanel("Bike Stations in Washington, D.C."),
               #          sidebarLayout(
               #            sidebarPanel(
               #              selectInput(
               #                "origin",
               #                label = "Origin Station",
               #                choices = stations$name,
               #              ),
               #              selectInput(
               #                "destination",
               #                label = "Destination Station",
               #                choices = stations$name,
               #              ),
               #              actionButton("route", "Get Route")
               #            ),
               #            mainPanel(
               #              leafletOutput("stationMap")
               #            )
               #          )
               # )

 )


# reuploaded version 12/2/2024


##
