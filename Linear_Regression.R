row_no <- 20
col_no <- 2

random_matrix <- matrix(runif((row_no*col_no),min=1,max=100),nrow=row_no,ncol=col_no)
random_df <- as.data.frame(random_matrix)

colnames(random_df) <- c("weight","height")
print(head(random_df))

model <- lm(height~weight,data=random_df)

inter <- coef(model)[1]
slope <- coef(model)[2]

print("Linear Regression")
cat("y=",round(slope,2)," * x + ",round(inter,2),"\n")

x <- random_df$weight
y <- random_df$height
png("linear_regression.png", width = 800, height = 600)

plot(
  x, y,
  main = "Simple Linear Regression",
  xlab = "Weight",
  ylab = "Height",
  pch = 16,
  col = "blue"
)

abline(model, col = "red", lwd = 2)

dev.off()
input=as.numeric(readline("Enter the new value of x :"))
p=predict(model,newdata=data.frame(weight=input))
cat(p)

