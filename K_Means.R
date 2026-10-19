data("iris")
iris_data <- iris[, 1:4]
print(head(iris_data))
set.seed(123)
kmeans_result <- kmeans(iris_data, centers = 3, nstart = 25)
iris$Cluster <- as.factor(kmeans_result$cluster)
print(kmeans_result)

plot(iris$Sepal.Length, iris$Sepal.Width,
     col = iris$Cluster,
     pch = 19,
     xlab = "Sepal Length",
     ylab = "Sepal Width",
     main = "K-Means Clustering")

points(kmeans_result$centers[,1],
       kmeans_result$centers[,2],
       col = 1:3,
       pch = 8,
       cex = 2)
