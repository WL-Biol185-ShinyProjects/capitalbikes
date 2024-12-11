stations <- read.csv("bike_numbers.csv")

routeME <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = mean(stations$longitude), lat = mean(stations$latitude), zoom = 15)
  })
  
  observeEvent(input$route, {
    origin <- stations %>% filter(name == input$origin) %>% select(longitude, latitude)
    destination <- stations %>% filter(name == input$destination) %>% select(longitude, latitude)
    
    
    directions <- mp_directions(
      origin = as.numeric(origin),
      destination = as.numeric(destination),
      key = Sys.getenv("MAPS_API"),
      mode = "bicycling",
      alternatives = FALSE
    )
    
    route <- mp_get_routes(directions)
    
    origin_coords <- paste(origin$latitude, origin$longitude, sep = ",")
    dest_coords <- paste(destination$latitude, destination$longitude, sep = ",")
    
    result <- gmapsdistance(
      origin = origin_coords,
      destination = dest_coords,
      mode = "bicycling",
      key = Sys.getenv("MAPS_API")
    )
    
    travel_time_seconds <- result$Time
    travel_time <- sprintf("%d hours %d minutes", travel_time_seconds %/% 3600, (travel_time_seconds %% 3600) %/% 60)
    
    
    
    
    # Get elevation data for origin and destination
    elevation_data <- get_elev_point(
      data.frame(
        x = c(origin$longitude, destination$longitude),
        y = c(origin$latitude, destination$latitude)
      ),
      prj = "EPSG:4326",
      units = "feet"
    )
    
    elevation_change <- diff(elevation_data$elevation)
    # elevation_gain <- max(0, elevation_diff)  # Only positive gain
    

    leafletProxy("map") %>%
      clearShapes() %>%
      addPolylines(data = route, color = "blue", weight = 3) %>%
      removeControl("elevation_info") %>%  # Remove previous control
      addControl(
        html = paste("Estimated travel time:", travel_time, 
                     "<br>Elevation change:", round(elevation_change, 2), "feet"),
        position = "topright",
        layerId = "elevation_info"  # Assign an ID to the control for easy removal
      ) %>%
      fitBounds(
        lng1 = min(origin$longitude, destination$longitude),
        lat1 = min(origin$latitude, destination$latitude),
        lng2 = max(origin$longitude, destination$longitude),
        lat2 = max(origin$latitude, destination$latitude)
        )
    })

}
  








# myRouter <- function(input, output, session) {
#   stations$color <- ifelse(stations$num_bikes_available <= 5, "red",
#                            ifelse(stations$num_bikes_available <= 15, "orange", 
#                                   "green"))
#   
#   
# o <- stations %>% filter(stations$name %in% input$origin)
# d <- stations %>% filter(stations$name %>% input$destination)
# 
# directions <- mp_directions(
#   origin = c(o$longitude, o$latitude),
#   destination = c(d$longitude, d$latitude),
#   key = Sys.getenv("MAPS_API"),
#   mode = c("bicycling")
# )
# 
# route <- mp_get_routes(directions)
# 
# pal = colorFactor(palette = "Dark2", domain = route$alternative_id)
# leaflet() %>% 
#   addProviderTiles("CartoDB.DarkMatter") %>%
#   addPolylines(data = route, opacity = 1, weight = 7, color = ~pal(alternative_id))
# 
# }