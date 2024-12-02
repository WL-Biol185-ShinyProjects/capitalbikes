library(shiny)
library(bslib)
library(markdown)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)

# Define UI


ui = navbarPage("Capital Bikes",
           tabPanel("Bike Station Map",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput("select", label = h3("Select box"),
                                    choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                    selected = 1),

                        hr(),
                        fluidRow(column(3, verbatimTextOutput("value")))


                        ),
                        mainPanel(
                         plotOutput("plot1")
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
                                plotlyOutput("dateduration"),
                                plotlyOutput("tempduration")
                              )
                            )
           ),
             tabPanel("tab 3",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput("select", label = h3("Select box"),
                                       choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                       selected = 1),

                           hr(),
                           # fluidRow(column(3, verbatimTextOutput("value")))


                         ),
                         mainPanel(
                           # plotOutput("plot1")
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
               # tabPanel("tab 5",
               #          sidebarLayout(
               #            sidebarPanel(
               #              selectInput("select", label = h3("Select box"),
               #                          choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
               #                          selected = 1),
               # 
               #              # hr(),
               #              # fluidRow(column(3, verbatimTextOutput("value")))
               # 
               # 
               #            ),
               #            mainPanel(
               #              plotOutput("plot1")
               #            )
               #          )
               # )
)



