matrix_a <- matrix(c(1,2,3,4),nrow=2,ncol=2)
matrix_b <- matrix(c(5,6,7,8),nrow=2,ncol=2)

print(matrix_a)
print(matrix_b)

print("Addition")
print(matrix_a+matrix_b)

print("Substraction")
print(matrix_b-matrix_a)

print("Element by element multiplication")
print(matrix_a*matrix_b)

print("Multiplication")
print(matrix_a%*%matrix_b)

print("Element by element Division") #10/3--> 3.333
print(matrix_a/matrix_b)

print("Floor Division") #10/3--> 3.333--> 3
print(matrix_a%/%matrix_b)

print("Transpose")
print(t(matrix_a))

print("Inverse")
print(solve(matrix_a))

print("Identity matrix")
print(diag(2))

print("Inverse Transpose ")
print(solve(t(matrix_a)))

print("Deteminant")
print(det(matrix_a))