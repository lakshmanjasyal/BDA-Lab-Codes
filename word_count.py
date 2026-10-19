from pyspark import SparkContext
import string

# 1. Initialize SparkContext
sc = SparkContext("local", "WordCountMapReduce")
sc.setLogLevel("ERROR")

# 2. Read input from the external file
lines_rdd = sc.textFile("wordcount_input.txt")

# 3. MAP PHASE with Punctuation Removal:
def clean_and_split(line):
    # Remove punctuation (like periods, commas) and convert to lowercase
    translator = str.maketrans('', '', string.punctuation)
    clean_line = line.lower().translate(translator)
    return clean_line.split()

words_rdd = lines_rdd.flatMap(clean_and_split)
mapped_rdd = words_rdd.map(lambda word: (word, 1))

# 4. REDUCE PHASE:
word_counts_rdd = mapped_rdd.reduceByKey(lambda acc, value: acc + value)

# 5. ACTION: Collect and print results
results = word_counts_rdd.collect()

print("--- Cleaned Word Count Results ---")
for word, count in results:
    print(f"{word}: {count}")

# 6. Stop Spark
sc.stop()
