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
                                h3("About Our Capital Bikes App"),
                                p("This Shiny app is designed to help users find bike stations, view how weather trends impact bike usage, and see the most popular stations city bikers use each month. 
         Use the tabs to navigate between features, and customize plots using the controls."),
                                plotlyOutput("dateduration"),
                                plotlyOutput("tempduration")
                              )
                            )
           ),
             tabPanel("tab 4",
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
               tabPanel("Station Frequency",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(inputId = "selectMonth", 
                                        label = h3("Select Month"),
                                        choices = c("January", "February", "March", "April", 
                                                    "May", "June", "July", "August", "September", "October", "November", "December"),
                                        selected = "January"),
                          ),
                          mainPanel(
                            plotlyOutput("selectedfreq", height="800px")
                          )
                        )
           ),
               # tabPanel("Bike Router",
               #          titlePanel("Bike Stations in Washington, D.C."),
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
               #              tableOutput("stationTable"),
               #              leafletOutput("stationMap")
               #            )
               #          )
               # )
                
 )


# reuploaded version 12/2/2024



