stations <- read.csv("bike_numbers.csv")

myRouter <- function(input, output, session) {
  stations$color <- ifelse(stations$num_bikes_available <= 5, "red",
                           ifelse(stations$num_bikes_available <= 15, "orange", 
                                  "green"))
  
  
o <- stations %>% filter(stations$name %in% input$origin)
d <- stations %>% filter(stations$name %>% input$destination)

directions <- mp_directions(
  origin = c(o$longitude, o$latitude),
  destination = c(d$longitude, d$latitude),
  key = Sys.getenv("MAPS_API"),
  mode = c("bicycling")
)

route <- mp_get_routes(directions)

pal = colorFactor(palette = "Dark2", domain = route$alternative_id)
leaflet() %>% 
  addProviderTiles("CartoDB.DarkMatter") %>%
  addPolylines(data = route, opacity = 1, weight = 7, color = ~pal(alternative_id))

}