set_row=20
set_col=5

random_matrix <- matrix(runif(set_row*set_col,min=1,max=100),nrow=set_row,ncol=set_col)
random_df <- as.data.frame(random_matrix)
colnames(random_df)<-c("a","b","c","d","e")
print(head(random_df))