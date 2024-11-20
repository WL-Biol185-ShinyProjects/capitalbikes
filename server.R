library(shiny)
library(bslib)
library(markdown)
library(knitr)

function(input, output) {
  output$plot1 <- renderPlot({
    plot1(cars, type=input$plotType)
  })
  
  output$plot2 <- renderPlot({
    plot2(cars, type=input$plotType)
  })
  
  output$janfreqmd <- renderUI({
    HTML(markdown::markdownToHTML(knit('jan_freq_graphs.Rmd', quiet = TRUE)))
  })
  
}


