
# source("stationSelector.r")
source("bikeRouter.r")

function(input, output) {
  
  # output$stationSelector <- mySERVERd(input, output),
  output$bikeRouter <- myRouter(input, output)
  
}






