from pyspark import SparkContext

sc = SparkContext("local", "SquareRDD")

data = [1, 2, 3, 4, 5, 6, 7, 8]

rdd = sc.parallelize(data, 4)

print("Number of partitions:", rdd.getNumPartitions())

print("Partitions:", rdd.glom().collect())

squared_rdd = rdd.map(lambda x: x * x)

print("Squared list:", squared_rdd.collect())

sc.stop()

