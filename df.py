from pyspark.sql import SparkSession

# 1. Create a SparkSession
spark = SparkSession.builder \
    .appName("Read CSV with Schema Inference") \
    .getOrCreate()

# 3. Read the CSV file into a DataFrame
df = spark.read \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .csv("iris.csv")

# 4. Print the inferred schema
print("Inferred Schema:")
df.printSchema()

# 5. Display the first 20 rows
print("Top 20 Rows:")
df.select(df.columns[:10]).show(20, truncate=False)

# 6. Stop the SparkSession
spark.stop()

