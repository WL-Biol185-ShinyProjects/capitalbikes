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
  
  marfreq <- readRDS("2023-station-frequency/202303_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  marfreq$start_station_name=gsub(" / ","/\n",marfreq$start_station_name,fixed=T)
  marfreq$start_station_name=gsub(" & "," &\n",marfreq$start_station_name,fixed=T)
  marfreq$start_station_name = factor(marfreq$start_station_name,levels=marfreq$start_station_name)
  
  aprfreq <- readRDS("2023-station-frequency/202304_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  aprfreq$start_station_name=gsub(" / ","/\n",aprfreq$start_station_name,fixed=T)
  aprfreq$start_station_name=gsub(" & "," &\n",aprfreq$start_station_name,fixed=T)
  aprfreq$start_station_name = factor(aprfreq$start_station_name,levels=aprfreq$start_station_name)
  
  mayfreq <- readRDS("2023-station-frequency/202305_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  mayfreq$start_station_name=gsub(" / ","/\n",mayfreq$start_station_name,fixed=T)
  mayfreq$start_station_name=gsub(" & "," &\n",mayfreq$start_station_name,fixed=T)
  mayfreq$start_station_name = factor(mayfreq$start_station_name,levels=mayfreq$start_station_name)
  
  junfreq <- readRDS("2023-station-frequency/202306_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  junfreq$start_station_name=gsub(" / ","/\n",junfreq$start_station_name,fixed=T)
  junfreq$start_station_name=gsub(" & "," &\n",junfreq$start_station_name,fixed=T)
  junfreq$start_station_name = factor(junfreq$start_station_name,levels=junfreq$start_station_name)
  
  julfreq <- readRDS("2023-station-frequency/202307_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  julfreq$start_station_name=gsub(" / ","/\n",julfreq$start_station_name,fixed=T)
  julfreq$start_station_name=gsub(" & "," &\n",julfreq$start_station_name,fixed=T)
  julfreq$start_station_name = factor(julfreq$start_station_name,levels=julfreq$start_station_name)
  
  augfreq <- readRDS("2023-station-frequency/202308_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  augfreq$start_station_name=gsub(" / ","/\n",augfreq$start_station_name,fixed=T)
  augfreq$start_station_name=gsub(" & "," &\n",augfreq$start_station_name,fixed=T)
  augfreq$start_station_name = factor(augfreq$start_station_name,levels=augfreq$start_station_name)
  
  sepfreq <- readRDS("2023-station-frequency/202309_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  sepfreq$start_station_name=gsub(" / ","/\n",sepfreq$start_station_name,fixed=T)
  sepfreq$start_station_name=gsub(" & "," &\n",sepfreq$start_station_name,fixed=T)
  sepfreq$start_station_name = factor(sepfreq$start_station_name,levels=sepfreq$start_station_name)
  
  octfreq <- readRDS("2023-station-frequency/202310_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  octfreq$start_station_name=gsub(" / ","/\n",octfreq$start_station_name,fixed=T)
  octfreq$start_station_name=gsub(" & "," &\n",octfreq$start_station_name,fixed=T)
  octfreq$start_station_name = factor(octfreq$start_station_name,levels=octfreq$start_station_name)
  
  novfreq <- readRDS("2023-station-frequency/202311_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  novfreq$start_station_name=gsub(" / ","/\n",novfreq$start_station_name,fixed=T)
  novfreq$start_station_name=gsub(" & "," &\n",novfreq$start_station_name,fixed=T)
  novfreq$start_station_name = factor(novfreq$start_station_name,levels=novfreq$start_station_name)
  
  decfreq <- readRDS("2023-station-frequency/202312_station_freq.rds") %>%
    filter(start_station_name!="")%>%
    arrange(desc(n)) %>%
    slice_head(n=10)
  decfreq$start_station_name=gsub(" / ","/\n",decfreq$start_station_name,fixed=T)
  decfreq$start_station_name=gsub(" & "," &\n",decfreq$start_station_name,fixed=T)
  decfreq$start_station_name = factor(decfreq$start_station_name,levels=decfreq$start_station_name)
  
  output$selectedfreq <- renderPlotly ({
    if (input$selectMonth == "January") {
      plot3 <- ggplot(janfreq, aes(start_station_name, n)) +
        geom_col(fill = "red") +
        labs(title = "January Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot3)
      }
    else if (input$selectMonth == "February") {
      plot4 <- ggplot(febfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "February Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot4)
    } 
    else if (input$selectMonth == "March") {
      plot5 <- ggplot(marfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "March Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot5)
    } 
    else if (input$selectMonth == "April") {
      plot6 <- ggplot(aprfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "April Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot6)
    }
    else if (input$selectMonth == "May") {
      plot7 <- ggplot(mayfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "May Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot7)
    }
    else if (input$selectMonth == "June") {
      plot8 <- ggplot(junfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "June Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot8)
    }
    else if (input$selectMonth == "July") {
      plot9 <- ggplot(julfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "July Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot9)
    }
    else if (input$selectMonth == "August") {
      plot10 <- ggplot(augfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "August Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot10)
    }
    else if (input$selectMonth == "September") {
      plot11 <- ggplot(sepfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "September Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot11)
    }
    else if (input$selectMonth == "October") {
      plot12 <- ggplot(octfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "October Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot12)
    }
    else if (input$selectMonth == "November") {
      plot13 <- ggplot(novfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "November Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot13)
    }
    else if (input$selectMonth == "December") {
      plot14 <- ggplot(decfreq, aes(start_station_name, n)) +
        geom_col(fill="red") +
        labs(title = "December Top 10 Start Stations", x = "Station Name", y = "Number of Pick-Ups") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
      ggplotly(plot14)
    }
  })
  
}
  
  
  
  
  

  
 



