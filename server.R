library(shiny)
library(bslib)
library(markdown)

function(input, output) {
  output$plot1 <- renderPlot({
    plot1(cars, type=input$plotType)
  })
  
  output$plot2 <- renderPlot({
    plot2(cars, type=input$plotType)
  })
  
}


