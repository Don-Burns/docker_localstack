from pyspark.sql import SparkSession

# spark = SparkSession.builder.master(
# "spark://spark:7070").appName("testing").config("spark.driver.host", "local[*]").getOrCreate()
spark = SparkSession.builder.appName("testing").getOrCreate()
