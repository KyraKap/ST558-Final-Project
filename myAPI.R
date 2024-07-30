#myAPI.R

install.packages("GGally")
install.packages("leaflet")
install.packages("plumber")
install.packages("caret")
install.packages("randomForest")
library(GGally)
library(leaflet)
library(plumber)
library(caret)
library(randomForest)

# read in the data
diabetes_data <- read.csv("/Users/kyrakapsaskis/ST558_Final_Project_Folder/ST558-Final-Project/diabetes_binary_health_indicators_BRFSS2015.csv")

# define the factor variables

factor_data <- diabetes_data %>%
  mutate( 
    Diabetes_factor = factor(Diabetes_binary, levels = c(0, 1), labels = c("No", "Yes")),
    HighBP_factor = factor(HighBP, levels = c(0, 1), labels = c("No", "Yes")),
    HighChol_factor = factor(HighChol, levels = c(0, 1), labels = c("No", "Yes")),
    Smoker_factor = factor(Smoker, levels = c(0, 1), labels = c("No", "Yes")),
    PhysActivity_factor = factor(PhysActivity, levels = c(0, 1), labels = c("No", "Yes")),
    Fruits_factor = factor(Fruits, levels = c(0, 1), labels = c("No", "Yes")),
    HvyAlcoholConsump_factor = factor(HvyAlcoholConsump, levels = c(0, 1), labels = c("No", "Yes")),
    AnyHealthcare_factor = factor(AnyHealthcare, levels = c(0, 1), labels = c("No", "Yes")),
    GenHlth_factor = factor(GenHlth, levels = c(1:5), labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
    Sex_factor = factor(Sex, levels = c(0, 1), labels = c("Female", "Male")),
    Age_factor = factor(Age, levels = c(1:13), labels = c("18-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80 or older"))
    
  )

# The best model was the random forest

set.seed(10)
rfFit_best_mtry <- train(Diabetes_factor ~ Age_factor + Sex_factor + HvyAlcoholConsump_factor + PhysActivity_factor + HighChol_factor + HighBP_factor + GenHlth_factor + AnyHealthcare_factor,
                         data = train,
                         method = "ranger",
                         trControl = trainControl(method = "cv",
                                                  number = 3),
                         preProcess = c("center", "scale"),
                         tuneGrid = data.frame(mtry = 10, splitrule="gini", min.node.size=1
                         )
)

# USED TO TEST THIS OUT THE API

#Echo the parameter that was sent in
#* @param msg The message to echo back
#* @get /echo
function(msg=""){
  list(msg = paste0("The message is: '", msg, "'"))
}

#http://localhost:PORT/echo?msg=Hey



# Predicting Diabetes
#* @param Age_factor
#* @param Sex_factor
#* @param HvyAlcoholConsump_factor
#* @param PhysActivity_factor
#* @param HighChol_factor
#* @param HighBP_factor
#* @param GenHlth_factor
#* @param AnyHealthcare_factor
#* @get /pred
function(Age_factor = "18-24",
         Sex_factor = "Female",
         HvyAlcoholConsump_factor = "No",
         PhysActivity_factor = "Yes",
         HighChol_factor = "No",
         HighBP_factor = "No",
         GenHlth_factor = "Excellent",
         AnyHealthcare_factor = "Yes") {
  
  new_data <- data.frame(
    Age_factor = factor(Age_factor, levels = levels(diabetes_data$Age_factor)),
    Sex_factor = factor(Sex_factor, levels = levels(diabetes_data$Sex_factor)),
    HvyAlcoholConsump_factor = factor(HvyAlcoholConsump_factor, levels = levels(diabetes_data$HvyAlcoholConsump_factor)),
    PhysActivity_factor = factor(PhysActivity_factor, levels = levels(diabetes_data$PhysActivity_factor)),
    HighChol_factor = factor(HighChol_factor, levels = levels(diabetes_data$HighChol_factor)),
    HighBP_factor = factor(HighBP_factor, levels = levels(diabetes_data$HighBP_factor)),
    GenHlth_factor = factor(GenHlth_factor, levels = levels(diabetes_data$GenHlth_factor)),
    AnyHealthcare_factor = factor(AnyHealthcare_factor, levels = levels(diabetes_data$AnyHealthcare_factor))
  )
  
  prediction <- predict(rfFit_best_mtry, new_data)
  list(prediction = prediction)
}


# My API Info section
#* API Info
#* @get /info
function() {
  return(list(
    name = "Kyra Kapsaskis",
    url = "https://github.com/KyraKap/ST558-Final-Project.git"
  ))
}


# Example endpoints

# example from class that I left in as a test
# curl -X 'GET' \ 'http://127.0.0.1:3037/echo?msg=Hey' \ -H 'accept: */*'


# curl -X 'GET' \ 'http://127.0.0.1:3037/info' \ -H 'accept: */*'
# curl http://127.0.0.1:3037/info

# curl -X 'GET' \ 'http://127.0.0.1:3037/pred?Age_factor=18-24&Sex_factor=Female&HvyAlcoholConsump_factor=No&PhysActivity_factor=Yes&HighChol_factor=No&HighBP_factor=No&GenHlth_factor=Excellent&AnyHealthcare_factor=Yes' \ -H 'accept: */*'
# http://127.0.0.1:3037/pred?Age_factor=18-24&Sex_factor=Female&HvyAlcoholConsump_factor=No&PhysActivity_factor=Yes&HighChol_factor=No&HighBP_factor=No&GenHlth_factor=Excellent&AnyHealthcare_factor=Yes
