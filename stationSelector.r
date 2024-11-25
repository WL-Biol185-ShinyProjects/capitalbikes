stations <- read.csv("bike_numbers.csv")

myUId <- tabPanel(
  titlePanel("Bike Stations in Washington, D.C."),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "name",
        label = "Origin Station",
        choices = stations$name,
      )
  ),

    mainPanel(
      tableOutput("stationTable"),
      leafletOutput("stationMap")
    )
  )
)

mySERVERd <- function(input, output, session) {
  
  stations$color <- ifelse(stations$num_bikes_available <= 5, "red",
                           ifelse(stations$num_bikes_available <= 15, "orange", "green"))
  

  output$stationTable <- renderTable({
    stations %>% filter(name == input$name)
  })
  
  output$stationMap <- renderLeaflet({
    req(input$name)
    
    station_data <- stations %>% filter(name == input$name)
    
    leaflet() %>%
      addProviderTiles(provider = providers$Esri.WorldImagery, group = "Satellite") %>%
      addTiles() %>%
      addCircleMarkers(
        data = stations,
        popup = ~paste(
        "<strong>Station Name:</strong>", name, "<br>",
        "<strong>Latitude:</strong>", latitude, "<br>",
        "<strong>Longitude:</strong>", longitude, "<br>",
        "<strong>Available Bikes:</strong>", num_bikes_available
      ),
      
        lat = ~latitude,
        lng = ~longitude,
        group = "Markers",
        color = ~color,
        radius = ~num_bikes_available
        ) %>%
      
      addLayersControl(
        baseGroups = c("Streets", "Satellite"),
        overlayGroups = c("Markers"),
        position = "topright"
      ) %>%
      setView(
        lng = station_data$longitude,
        lat = station_data$latitude,
        zoom = 15
      )
  })
}
