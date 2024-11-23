library(shiny)
library(bslib)
library(markdown)
library(knitr)

function(input, output) {
  weather_data <- read.csv("~/BIO185Evs/mergedweatherdata.csv")
  weather_data$Date=as.Date(weather_data$Date)
  output$myplot <- renderPlot({
    if(input$plotType=="p"){
    result=ggplot(weather_data, aes(x=Date, y=Duration)) + geom_point() + 
      labs(title="Date vs Ride Duration", x= "Date", y= "Average Ride Duration (mins)") +
      theme_minimal()
    }
    if(input$plotType=="l"){
      result=ggplot(weather_data, aes(x=Date, y=Duration)) + geom_line() + 
        labs(title="Date vs Ride Duration", x= "Date", y= "Average Ride Duration (mins)") +
        theme_minimal()
    }
    return(result)
  })
  
  output$myplot2 <- renderPlot({
    ggplot(mergedweatherdata, aes(Date, Duration, color=Tempavg)) + geom_point ()
  })
  
  output$janfreqmd <- renderUI({
    HTML(markdown::markdownToHTML(knit('jan_freq_graphs.Rmd', quiet = TRUE)))
  })
  
}


