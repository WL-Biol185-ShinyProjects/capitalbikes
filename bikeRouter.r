stations <- read.csv("bike_numbers.csv")


# myRUI <- tabPanel(
#   titlePanel("Bike Stations in Washington, D.C."),
#   sidebarLayout(
#     sidebarPanel(
#       selectInput(
#         "origin",
#         label = "Origin Station",
#         choices = stations$name,
#       ),
#       selectInput(
#         "destination",
#         label = "Destination Station",
#         choices = stations$name,
#       ),
#       actionButton("route", "Get Route")
#     ),
#     mainPanel(
#       tableOutput("stationTable"),
#       leafletOutput("stationMap")
#     )
#   )
# )



myRouter <- function(input, output, session) {
  stations$color <- ifelse(stations$num_bikes_available <= 5, "red",
                           ifelse(stations$num_bikes_available <= 15, "orange", 
                                  "green"))
  
  
  output$stationTable <- renderTable({
    stations %>% filter(name == input$origin)
  })
  
  route_data <- reactiveVal(NULL)
  
  observeEvent(input$route, {
    origin <- stations[stations$name == input$origin, ]
    destination <- stations[stations$name == input$destination, ]
    
    route <- mp_directions(
      origin = c(origin$longitude, origin$latitude),
      destination = c(destination$longitude, destination$latitude),
      key = "AIzaSyDzjM-Dmm3EB4VhNfo23I4Tn0pQ832rAVc",
      mode = "bicycling"
  )
  
  route_data(route)

  })
  
  
  output$stationMap <- renderLeaflet({
    req(input$origin)
    
    station_data <- stations %>% filter(name == input$origin)
    
    map <- leaflet() %>%
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
     route <- route_data()
     
     
    if(!is.null(route)) {
     # route_coords <- get_coordinates(route_data())
      route_path <- route$routes[[1]]$legs[[1]]$points
      map <- map %>%
        addPolylines(
          lat = sapply(route_path, function(point) point$lat),
          lng = sapply(route_path, function(point) point$lon),
          color = "blue",
          weight = 3,
          opacity = 0.8,
          group = "Route"
        )
    }
    
    map
    
  })
  
}

