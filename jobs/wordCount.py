from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("WordCount").getOrCreate()
data = spark.read.text("/opt/spark/README.md")  # Spark comes with a README
word_counts = data.rdd.flatMap(lambda line: line.value.split(" ")) \
    .map(lambda word: (word, 1)) \
    .reduceByKey(lambda a, b: a + b)
word_counts.saveAsTextFile("/opt/spark/jobs/output")
spark.stop()
