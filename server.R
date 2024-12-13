library(shiny)
library(bslib)
library(markdown)
library(knitr)
library(ggplot2)
library(plotly)
library(tidyverse)
library(dplyr)
library(gmapsdistance)
library(elevatr)


function(input, output, session) {
  
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
    # if(input$plotType=="p"){
      plot2=ggplot(filtered_temp_data(), aes(Tempavg, Duration)) + geom_point (color="red") +
        geom_smooth(method = "loess", color = "black", linewidth = 0.8, se = FALSE) +
        labs(title="Average Temperature vs Ride Duration", x= "Average Temperature", y= "Average Ride Duration (mins)") +
        theme_minimal()
    # }
    # else if(input$plotType=="b"){
    #   plot2=ggplot(filtered_temp_data(), aes(x = Tempavg, y = Duration)) +
    #     geom_bar(stat = "identity", fill = "red") +
    #     geom_smooth(method = "loess", color = "black", linewidth = 0.8, se = FALSE) +
    #     labs(title = "Average Temperature vs Ride Duration", x = "Average Temperature", y = "Average Ride Duration (mins)") +
    #     theme_minimal()+
    #     theme(axis.text.x = element_text(angle = 45, hjust = 1))
    # }
    ggplotly(plot2)
  })
  
  weather <- read.csv("mergedweatherdata.csv")
  
  rain <- filter(weather, Preciptype == "rain")
  rainavg <- mean(rain$Duration)
  
  noprecip <- filter(weather, is.na(Preciptype))
  noprecipavg <- mean(noprecip$Duration)
  
  snow <- filter(weather, Preciptype == "rain,snow" | Preciptype == "snow")
  snowavg <- mean(snow$Duration)
  
  freezingrain <- filter(weather, Preciptype == "freezingrain" | Preciptype == "rain,freezingrain")
  freezingrainavg <- mean(freezingrain$Duration)
  
  
  df <- data.frame(
    preciptype=c("No Precipitation","Rain","Freezing Rain","Snow") ,  
    durationavg=c(noprecipavg,rainavg,freezingrainavg,snowavg)
  )
  
  output$precipduration <- renderPlot({
    ggplot(df, aes(x = preciptype, y = durationavg)) +
      geom_bar(stat = "identity", fill = "red") +
      labs(
        title = "Average Ride Duration by Precipitation Type",
        x = "Type of Precipitation",
        y = "Average Ride Duration (mins)"
      ) +
      theme_minimal()
  })
  
  
  
  
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
  
  output$stationBlurb <- renderText({
    req(input$stationName)  
    
    
    stationBlurbs <- list(
      "Columbus Circle/ Union Station" = "Union Station is the busiest start station for Capital Bike users. It is also one of the busiest train stations in the United States. In Union Station, you can find an assortment of shops and food options. Nearby to Union station, you can visit the U.S. Capitol, explore the different Smithsonian museums like the National Museum of Natural History or the National Museum of American History, appriciate artwork at the National Gallery of Art, wander through the National Postal Museum, or visit the Library of Congress- all just a quick bike ride away!",
      "New Hampshire Ave & T St NW" = "This station is consistently one of the buisiest stations for Capital Bikeshare users. Close to Dupont Cirlce, this staion is also near The Phillips Collection – a world-renowned art museum with works by Picasso, Rothko, and Van Gogh. From here, the White House is also very accesible by bike.",
      "15th & P St NW" = "From this station, Logan Circle is just a few blocks away. This residential area has a beautiful public park in the very center and is surrounded by Victorian houses. It lends itself to a lazy Sunday afternoon stroll and has cafes such as The Roasted Boon Co. and Slipstream. If you're looking for a bike destination, try The Washington National Cathedral, a DC architectural landmark, which is only a 15 minute bike ride way.",
      "5th & K St NW" = "In the heart of downtown, this station is close to Penn Quarter. Here, you can visit the National Portrait Gallery, the Smithsonian American Art Museum, and the Capital One Arena to catch a Washington Wizards game or a concert. Bike 7 minutes west to reach Lafayette park.",
      "1st & M St NE" = "Union Market is closeby to this station and includes a trendy food hub with local eateries and vendors. It's also close to the H Street Corridor which has great nightlife. Pick up a bike and ride 10 minutes to the Atlas District- DC's arts and entertainment neighborhood- or head west towards the U.S. Capitol and explore the the Library of Congress.",
      "14th & V St NW" = "This station is in the historic U Street Corridor, where you can find American cultural landmarks. Visit the African American Civil War Museum and iconic jazz venues like the 9:30 Club. From here, cycle toward the National Mall and visit monuments like the Washington Monument and the U.S. Capitol.",
      "14th & R St NW" = "A short distance from the Logan Circle neighborhood, this area features excellent restaurants, local shops, and beautiful Victorian row houses. Bike down to the National Mall or head toward the Dupont Circle area, known for its shops, cafes, and welcoming community.",
      "17th & Corcoran St NW" = "In the Dupont Circle neighborhood, this station is close to The Phillips Collection – a world-renowned art museum with works by Picasso, Rothko, and Van Gogh -  and the many cafes and shops around Dupont Circle. The Smithsonian Museums and the National Gallery of Art are a short 5-10 minute ride away.",
      "8th & O St NW" = "This station is near the Shaw neighborhood, known for its African American history and revitalized community. The historic Howard Theatre and the African American Civil War Memorial are within walking distance. Bike south towards the National Mall to see the monuments, or bike to the U Street Corridor for its nightlife and drop your bike at the 14th & V St NW station.",
      "Eastern Market Metro/ Pennsylvania Ave & 8th St SE" = "Eastern Market is one of DC's oldest markets. Here, you can shop for fresh produce, local meats, and even handmade art. Nearby, you’ll find Barracks Row and the historic Capitol Hill neighborhood. Bike towards the National Mall, or head north to the U.S. Capitol and the Library of Congress.",
      "Massachusetts Ave & Dupont Circle NW" = "Around Dupont Circle, you'll find cafes, art galleries, and unique boutiques. Dupont Circle itself hosts beautuil gardens you are welcome to explore. The White House is a 7 minute bike ride away from Dupont Cirlce.",
      "Jefferson Memorial" = "The Jefferson Memorial is a neoclassical monument depicting Thomas Jefferson, a bit removed from the other monuments at the National Mall. Admire the the Tidal Basin and the Washington Monument from a distance. Bike around the Tidal Basin, or bike to the nearby Martin Luther King Jr. Memorial and Franklin Delano Roosevelt Memorial, also removed from the National Mall. The Lincoln Memorial and the National World War II Memorial are a 5 minute bike ride away.",
      "Smithsonia-National Mall/ Jefferson Dr & 12th St SW" = "From this station, go to the National Museum of American History, National Museum of Natural History, and National Air and Space Museum- all for free. Walk through the National Mall and see the Washington Monument. Just a half mile away is the Hirshhorn Museum and Sculpture Garden, a well-known art museum, which is only 3 minutes away by bike.",
      "Lincoln Memorial" = "The famous Lincoln Memorial is at this station. Enjoy the Reflecting Pool and Washington Monument, walk along the National Mall and visit other nearby monuments, like the Vietnam Veterans Memorial and the Korean War Veterans Memorial.The National World War II Memorial is a 3 minute bike ride east, and the White House and Lafayette Park are just 10 minutes north.",
      "Henry Bacon Dr & Lincoln Memorial Circle NW" = "Similar to the Lincoln Memorial station, you can explore the monument and the surrounding area. This is a great starting point for a bike ride around the Tidal Basin or along the National Mall.",
      "4th St & Madison Dr NW" = "This station is located near the National Gallery of Art. Stop by the National Archives to see the original U.S. Constitution, Bill of Rights, and Declaration of Independence! You can bike to the Smithsonian Institution or The National Gallery of Art Sculpture Garden, both 3 minutes away by bike.",
      "M St & Delaware Ave NE" = "From here, explore the Union Market district with its hip food vendors and local shops and boutiques. Ride through the beautiful Capitol Hill neighborhood and admire the historic homes. Union station is a 5 minute ride away.",
      "Adams Mill & Columbia Rd NW" = "A bit way from city center, visit the Adams Morgan neighborhood, known for its diverse cultural scene and great nightlife. 8 minutes away by bike, The National Zoo is a free and family-friendly destination with hundreds of animals and exhibits."
      
    )
    
    
    station <- trimws(tolower(input$stationName))  
    matchedStation <- names(stationBlurbs)[tolower(names(stationBlurbs)) == station]
    
    if (length(matchedStation) == 0) {
      "Station not found. Please try entering a valid station name."
    } else {
      stationBlurbs[[matchedStation]]
    }
  })
  
  
  
  
  # this solves merge conflict
  source("stationSelector.r")
  output$stationSelect <- mySERVERd(input, output)

  # Bike router server logic here:
  stations <- read.csv("total_bikes.csv")
  
  stations$color <- ifelse(stations$total_bikes_available <= 5, "red",
                           ifelse(stations$total_bikes_available <= 15, "orange", "green"))
  
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(provider = providers$Esri.WorldImagery, group = "Satellite") %>%
      addTiles() %>%
      addLayersControl(
        baseGroups = c("Streets", "Satellite"),
        position = "topleft"
      ) %>%
      
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

    origin_coordinates <- paste(origin$latitude, origin$longitude, sep = ",")
    destination_coordinates <- paste(destination$latitude, destination$longitude, sep = ",")

    result <- gmapsdistance(
      origin = origin_coordinates,
      destination = destination_coordinates,
      mode = "bicycling",
      key = Sys.getenv("MAPS_API")
    )

    travel_time_seconds <- result$Time
    travel_time <- sprintf("%d hours %d minutes", travel_time_seconds %/% 3600, (travel_time_seconds %% 3600) %/% 60)


    # Elevation data for origin and destination
    elevation_data <- get_elev_point(
      data.frame(
        x = c(origin$longitude, destination$longitude),
        y = c(origin$latitude, destination$latitude)
      ),
      prj = "EPSG:4326",
      units = "feet"
    )

    elevation_change <- diff(elevation_data$elevation)

    bikeIcon <- makeIcon(
      iconUrl = "https://i.postimg.cc/4xyRN8t9/bikeicon.png",
      iconWidth = 30, iconHeight = 30
    )

    leafletProxy("map") %>%
      clearShapes() %>%
      clearMarkers() %>%
      removeControl("elevation_info") %>% 
      addPolylines(data = route, color = "blue", weight = 8) %>%
      addMarkers(
        data = route,
        lng = c(origin$longitude, destination$longitude),
        lat = c(origin$latitude, destination$latitude),
        icon = bikeIcon,
        popup = c("Origin Station", "Destination Station")
      ) %>%
      addControl(
        html = paste("Estimated travel time:", travel_time,
                     "<br>Elevation change:", round(elevation_change, 2), "feet"),
        position = "topright",
        layerId = "elevation_info" 
      ) %>%
      fitBounds(
        lng1 = min(origin$longitude, destination$longitude),
        lat1 = min(origin$latitude, destination$latitude),
        lng2 = max(origin$longitude, destination$longitude),
        lat2 = max(origin$latitude, destination$latitude)
      )
  })

}







