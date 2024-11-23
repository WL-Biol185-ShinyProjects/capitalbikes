library(shiny)
library(bslib)
library(markdown)
library(ggplot2)
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
              tabPanel("Weather Statistics",
                        sidebarLayout(
                            sidebarPanel(
                              radioButtons("plotType", "Plot type",
                                           c("Scatter"="p", "Line"="l")
                                )
                              ),
                              mainPanel(
                                plotOutput("myplot2"),
                                plotOutput("myplot")
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
                            selectInput("select", label = h3("Select Month"),
                                        choices = list("January" = 1, "February" = 2, "March" = 3),
                                        selected = 1),


                            # fluidRow(column(3, verbatimTextOutput("value")))


                          ),
                          mainPanel(
                            uiOutput("janfreqmd")
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
               #              hr(),
               #              fluidRow(column(3, verbatimTextOutput("value")))
               # 
               # 
               #            ),
               #            mainPanel(
               #              plotOutput("plot1")
               #            )
               #          )
               # )

)


