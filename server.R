library(shiny)
library(bslib)
library(markdown)
library(knitr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)


function(input, output) {
  
  weather_data <- read.csv("mergedweatherdata.csv")
  weather_data$Date=as.Date(weather_data$Date)
  
  filtered_date_data <- reactive({
    weather_data[weather_data$Date >= input$date_slider[1] &
                        weather_data$Date <= input$date_slider[2], ]
  })
  
  filtered_temp_data <- reactive({
    weather_data[weather_data$Tempavg >= input$temp_slider[1] &
                        weather_data$Tempavg <= input$temp_slider[2], ]
  })
  
  
  output$dateduration <- renderPlotly({
    if(input$plotType=="p"){
    plot1=ggplot(filtered_date_data(), aes(x=Date, y=Duration)) + geom_point(color="red") + 
      geom_smooth(method = "loess", color = "black", linewidth = 0.8, se = FALSE) +
      labs(title="Date vs Ride Duration", x= "Date", y= "Average Ride Duration (mins)") +
      theme_minimal()
    }
    else if(input$plotType=="b"){
      plot1=ggplot(filtered_date_data(), aes(x = Date, y = Duration)) + 
        geom_bar(stat = "identity", fill = "red") + 
        geom_smooth(method = "loess", color = "black", linewidth = 0.8, se = FALSE) +
        labs(title = "Date vs Ride Duration", x = "Date", y = "Average Ride Duration (mins)") + 
        theme_minimal()+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
    ggplotly(plot1)
  })
  
  output$tempduration <- renderPlotly({
    if(input$plotType=="p"){
    plot2=ggplot(filtered_temp_data(), aes(Tempavg, Duration)) + geom_point (color="red") +
      geom_smooth(method = "lm", color = "black", linewidth = 0.8, se = FALSE) +
      labs(title="Average Temperature vs Ride Duration", x= "Average Temperature", y= "Average Ride Duration (mins)") +
      theme_minimal()
    }
    else if(input$plotType=="b"){
      plot2=ggplot(filtered_temp_data(), aes(x = Tempavg, y = Duration)) +
        geom_bar(stat = "identity", fill = "red") +
        geom_smooth(method = "lm", color = "black", linewidth = 0.8, se = FALSE) +
        labs(title = "Average Temperature vs Ride Duration", x = "Average Temperature", y = "Average Ride Duration (mins)") +
        theme_minimal()+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    }
    ggplotly(plot2)
  })
  
  # output$janfreqmd <- renderUI({
  #   HTML(markdown::markdownToHTML(knit('jan_freq_graphs.Rmd', quiet = TRUE)))
  # })
  
  janfreq <- readRDS("2023-station-frequency/202301_station_freq.rds") %>%
  filter(start_station_name!="")%>%
  arrange(desc(n)) %>%
  slice_head(n=10)
  janfreq$start_station_name=gsub(" / ","/\n",janfreq$start_station_name,fixed=T)
  janfreq$start_station_name=gsub(" & "," &\n",janfreq$start_station_name,fixed=T)
  janfreq$start_station_name = factor(janfreq$start_station_name,levels=janfreq$start_station_name)
  
  febfreq <- readRDS("2023-station-frequency/202302_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  febfreq$start_station_name=gsub(" / ","/\n",febfreq$start_station_name,fixed=T)
  febfreq$start_station_name=gsub(" & "," &\n",febfreq$start_station_name,fixed=T)
  febfreq$start_station_name = factor(febfreq$start_station_name,levels=febfreq$start_station_name)
  
  
  output$selectedfreq <- renderPlotly ({
    if (input$select == 1) {
      plot3 <- ggplot(janfreq, aes(start_station_name, n)) +
        geom_col(fill = "red") +
        labs(title = "January Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot3)
    } else if (input$select == 2) {
      plot4 <- ggplot(febfreq, aes(start_station_name, n)) +
        geom_col() +
        labs(title = "February Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot4)
    } 
  })
  
}
  
  
  
  
  

  
 



