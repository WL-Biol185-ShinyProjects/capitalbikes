library(shiny)
library(bslib)
library(markdown)

# Define UI


navbarPage("Capital Bikes",
           tabPanel("tab 1",
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
              tabPanel("tab 2",
                        sidebarLayout(
                            sidebarPanel(
                              radioButtons("plotType", "Plot type",
                                           c("Scatter"="p", "Line"="l")
                                )
                              ),
                              mainPanel(
                                plotOutput("plot2")
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
                            fluidRow(column(3, verbatimTextOutput("value")))
                            
                            
                          ),
                          mainPanel(
                            plotOutput("plot1")
                          )
                        )
            ),
               tabPanel("tab 4",
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
               tabPanel("tab 5",
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
               )          
           
)


