
# Created by Easton White

# Calculate quasi-R squared value (based on pg. 218 of Zuur et al 2009)


R2 <- function(model){
  return(100*(model$null.deviance - model$deviance)/(model$null.deviance))
}
