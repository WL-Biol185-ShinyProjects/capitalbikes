function(input, output, session) {
  
  # import station names and coordinates
  stations <- read.csv('bike_numbers.csv')
  
  # output the selection directly
  req(input$select_station_1)
  
  # output$select_station_1 = renderText( filter(stations, names == input$select_station_1)
  
  selected_station <- filter(stations, name == input$select_station_1)
  
  
  
  
  # # output the selection via the reactive
  # output$station_begin = renderText({
  #   req(userStart)
  #   paste0('The start station I selected is ', userStart())
  # })
  #
  
  # output$station_coord = renderText({
  #   filter(stations, name == input$select_station_1)
  #   paste0(input$select_station_1[5:6])
  # 
  # })
  
}
