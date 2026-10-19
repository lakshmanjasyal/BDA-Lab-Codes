from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder \
    .getOrCreate()

df = spark.read.csv(
    "iris1.csv",
    header=True,
    inferSchema=True
)

# Q1
print("Q1\n")
df.printSchema()
df.show(20)


# Q2
print("\nQ2\n")
df.filter(col("`petal.length`") < 1.4).show()


# Q3
print("\nQ3\n")

# AND
print("\nAND operation\n")
and_df = df.filter(
    (col("`sepal.width`") < 3.5) &
    (col("`petal.width`") > 0.2)
)
and_df.show()

# OR
print("\nOR operation\n")
or_df = df.filter(
    (col("`sepal.width`") < 3.5) |
    (col("`petal.width`") > 0.2)
)
or_df.show()

# NOT
print("\nNOT operation\n")
not_df = df.filter(
    (col("`sepal.width`") < 3.5) &
    ~(col("`petal.width`") > 0.2)
)
not_df.show()


# Q4
print("\nQ4\n")

result = df.filter(
    col("`petal.width`") == 2.0
).collect()

print(result)


# Q5
print("\nQ5\n")

first_row_dict = result[0].asDict()

print(first_row_dict)

for key, value in first_row_dict.items():
    print(key, value)


