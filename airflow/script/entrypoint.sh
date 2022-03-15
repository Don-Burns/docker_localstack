#!/usr/bin/env bash

# Move to the AIRFLOW HOME directory
cd $AIRFLOW_HOME

# Export environement variables
export AIRFLOW__CORE__LOAD_EXAMPLES=False

# Initiliase the metadatabase
airflow db init

# Create User
airflow users create -e "admin@airflow.com" -f "airflow" -l "airflow" -p "admin" -r "Admin" -u "admin"

sleep 10

# Run the scheduler in background
airflow scheduler &> /dev/null &

sleep 10

# Run the web sever in foreground (for docker logs)
exec airflow webserver
