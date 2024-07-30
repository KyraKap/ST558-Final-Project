#myAPI.R

install.packages("GGally")
install.packages("leaflet")
install.packages("plumber")
library(GGally)
library(leaflet)
library(plumber)

#THIS IS AN EXAMPLE

# # Send a message~
# #* @get /readme~
# function(){
#   "This is our basic API"
# }
# 
# #http://localhost:PORT/readme~



# USED TO TEST THIS OUT THE API

#Echo the parameter that was sent in
#* @param msg The message to echo back
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#http://localhost:PORT/echo?msg=Hey




# THIS IS WHAT I TYPED INTO MY COMPUTER TERMINAL
# docker image ls
# docker run -p 8000:8000 rapi
# http://127.0.0.1:8000/