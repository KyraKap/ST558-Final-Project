#myAPI.R

install.packages("GGally")
install.packages("leaflet")
install.packages("plumber")

library(GGally)
library(leaflet)
library(plumber)

# Send a message~
#* @get /readme~
function(){
  "This is our basic API"
}

#http://localhost:PORT/readme~


#Echo the parameter that was sent in
#* @param msg The message to echo back
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#http://localhost:PORT/echo?msg=Hey
