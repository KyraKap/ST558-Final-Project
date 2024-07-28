#Run my API

library(plumber)
r <- plumb("FinalAPI.R")

#run it on the port in the Dockerfile
r$run(port=8000)

