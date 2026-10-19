my_data <- iris
print("Original Dataset: ")
print(head(my_data))

my_data[3:6,"Sepal.Width"] <- NA
print("Dataset after introducing null values ")
print(my_data[1:6, c("Sepal.Length", "Sepal.Width")])

print("Check is there any null value in dataset")
print(colSums(is.na(my_data)))

my_data$Sepal.Width[is.na(my_data$Sepal.Width)] <- mean(my_data$Sepal.Width,na.rm=TRUE)
print(my_data[1:6,c("Sepal.Length","Sepal.Width")])

min_max_norm <- function(x){
  return((x-min(x))/(max(x)-min(x)))
}
normalized_dataset <- as.data.frame(lapply(my_data[1:4],min_max_norm))
normalized_dataset$Species <-my_data$Species
print(head(normalized_dataset))