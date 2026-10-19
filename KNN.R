# Install packages (run only once if not installed)
# install.packages("class")
# install.packages("caret")
# install.packages("ggplot2")
# install.packages("mlbench")

# Load packages
library(class)
library(caret)
library(ggplot2)
library(mlbench)

# Load the breast cancer dataset

data("BreastCancer")
bc_data <- BreastCancer

# View the data structure
head(bc_data)
str(bc_data)

# Remove unnecessary ID column
bc_data$Id <- NULL

# Remove missing values (KNN and normalization fail if NAs are present)
bc_data <- na.omit(bc_data)

# Rename 'Class' to 'diagnosis' to match your script
names(bc_data)[names(bc_data) == "Class"] <- "diagnosis"

# Convert feature columns from factor/ordered to numeric
feature_cols <- setdiff(names(bc_data), "diagnosis")
bc_data[feature_cols] <- lapply(bc_data[feature_cols], function(x) as.numeric(as.character(x)))

# Separate features (X) and target (Y)
X <- bc_data[, feature_cols]
Y <- bc_data$diagnosis

# Normalize the features
normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

X <- as.data.frame(lapply(X, normalize))

# Set seed for reproducibility
set.seed(123)

# Split data into training and testing sets (80% train, 20% test)
train_index <- createDataPartition(Y, p = 0.8, list = FALSE)

X_train <- X[train_index, ]
X_test  <- X[-train_index, ]

Y_train <- Y[train_index]
Y_test  <- Y[-train_index]

# Apply KNN with k = 5
k <- 5
predictions <- knn(
  train = X_train,
  test = X_test,
  cl = Y_train,
  k = k
)

# Display predictions
print(predictions)

# Create a data frame for plotting actual vs predicted classes
plot_data <- data.frame(
  Actual = Y_test,
  Predicted = predictions
)

# Test different K values (1 to 15) for accuracy loop
K_values <- 1:15
accuracy_values <- numeric(length(K_values))

for (j in 1:length(K_values)){
  p <- knn(X_train, X_test, Y_train, K_values[j])
  accuracy_values[j] <- mean(p == Y_test)
}

# Plot class distribution barplot
barplot(
  table(bc_data$diagnosis),
  col = c('green', 'red'),
  main = 'Benign VS Malignant cases',
  xlab = 'Diagnosis',
  ylab = 'Number of Cases'
)

# Plot KNN accuracy vs K value
plot(
  K_values,
  accuracy_values * 100,
  type = "b",
  pch = 19,
  col = 'black',
  lwd = 2,
  main = 'KNN Accuracy vs K Value',
  xlab = 'K Value',
  ylab = 'Accuracy (%)'
)
grid()

# ---------------------------------------
# CONFUSION MATRIX PLOT
# ---------------------------------------

# Create confusion matrix using caret
cm <- confusionMatrix(predictions, Y_test)

# Print confusion matrix statistics to console
print(cm)

# Extract confusion matrix values
cm_table <- as.matrix(cm$table)

# Get row and column names
row_names <- rownames(cm_table)
col_names <- colnames(cm_table)

# Create colors for the matrix cells
colors <- matrix(
  c("yellow", "red",
    "red", "yellow"),
  nrow = 2,
  byrow = TRUE
)

# Create empty plot for the confusion matrix
plot(
  0, 0,
  type = "n",
  xlim = c(0, 2),
  ylim = c(0, 2),
  xaxt = "n",
  yaxt = "n",
  xlab = "Actual Diagnosis",
  ylab = "Predicted Diagnosis",
  main = "KNN Confusion Matrix",
  asp = 1
)

# Draw the four cells
for (i in 1:2) {
  for (j in 1:2) {
    rect(
      xleft = j - 1,
      ybottom = 2 - i,
      xright = j,
      ytop = 3 - i,
      col = colors[i, j],
      border = "black",
      lwd = 2
    )
    
    text(
      x = j - 0.5,
      y = 2.5 - i,
      labels = cm_table[i, j],
      cex = 2.5,
      font = 2
    )
  }
}

# Add axis labels
axis(
  1,
  at = c(0.5, 1.5),
  labels = col_names,
  cex.axis = 1.2
)

axis(
  2,
  at = c(1.5, 0.5),
  labels = row_names,
  cex.axis = 1.2
)

# Add a box around the whole matrix
box(lwd = 2)