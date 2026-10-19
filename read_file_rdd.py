from pyspark import SparkContext

sc = SparkContext("local", "RDDFromExternalFile")


rdd = sc.textFile("input.txt")


print("RDD Contents:")
for line in rdd.collect():
    print(line)

print("Number of lines:", rdd.count())

sc.stop()

