library(shiny)
library(bslib)
library(markdown)
library(knitr)


function(input, output) {
  
  weather_data <- read.csv("~/BIO185Evs/mergedweatherdata.csv")
  weather_data$Date=as.Date(weather_data$Date)
  
  output$dateduration <- renderPlot({
    if(input$plotType=="p"){
    ggplot(weather_data, aes(x=Date, y=Duration)) + geom_point() + 
      geom_smooth(method = "loess", color = "black", linewidth = 1.2, se = FALSE) +
      labs(title="Date vs Ride Duration", x= "Date", y= "Average Ride Duration (mins)") +
      theme_minimal()
    }
    else if(input$plotType=="b"){
      ggplot(weather_data, aes(x = Date, y = Duration)) + 
        geom_bar(stat = "identity", fill = "black") + 
        labs(title = "Date vs Ride Duration", x = "Date", y = "Average Ride Duration (mins)") + 
        theme_minimal()+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
  })
  
  output$tempduration <- renderPlot({
    if(input$plotType=="p"){
    ggplot(weather_data, aes(Tempavg, Duration)) + geom_point () +
      geom_smooth(method = "lm", color = "black", linewidth = 1.2, se = FALSE) +
      labs(title="Average Temperature vs Ride Duration", x= "Average Temperature", y= "Average Ride Duration (mins)") +
      theme_minimal()
    }
    else if(input$plotType=="b"){
      ggplot(weather_data, aes(x = Tempavg, y = Duration)) + 
        geom_bar(stat = "identity", fill = "black") + 
        labs(title = "Average Temperature vs Ride Duration", x = "Average Temperature", y = "Average Ride Duration (mins)") + 
        theme_minimal()+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
    
  })
  
  output$janfreqmd <- renderUI({
    HTML(markdown::markdownToHTML(knit('jan_freq_graphs.Rmd', quiet = TRUE)))
  })
  
}
  
 



