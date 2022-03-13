# Goal
This repo's goal is to build a fully featured data engineering stack on 1 local machine for development purposes.
As such standards may not be fully production ready, but rather good enough that code can be fully developed and tested before deployment to any live environment and when deployed to the proper testing or production ready installations there should be minimal issues caused by mismatch of versions or syntax errors.
For use with specific cloud services or vendors alterations to the compose files may be needed to pass in credentials from the local machine or environment variables.  Where possible this should be done in either .env files or, for passwords and usernames, from a secrets manager.

# Stack
- Apache Spark
- Apache Airflow
- Apache Kafka