# syntax=docker/dockerfile:1
FROM ubuntu:18.04
# FROM python:3.8 # to consider using python image?

ENV LANG C.UFT-8
ENV DEBIAN FRONTEND noninteractive

ARG SCALA_VERSION=2.12
ARG SPARK_VERSION=3.2.0
ARG HADOOP_VERSION=2.7
ARG PYTHON_VERSION=3.8
ARG PY4J=py4j-0.10.9.2-src.zip

# install gen stuff
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    wget

# install python
RUN set -ex && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION}
#remove existing python ver
RUN apt autoremove -y python3.6 
# set python pref to desired vresion
RUN update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1

# install openjdk 11
RUN apt-get install -y --no-install-recommends \
    openjdk-11-jdk && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

# install spark
ENV SPARK_TMP_FILENAME="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
ENV SPARK_TMP_FOLDER="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

ENV SPARK_HOME="/opt/spark"
RUN mkdir ${SPARK_HOME}

RUN wget "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_TMP_FILENAME}" && \
    tar -xvzf ${SPARK_TMP_FILENAME} && \
    mv ${SPARK_TMP_FOLDER} spark && \
    mv spark /opt/ && \
    rm -rf ${SPARK_TMP_FILENAME}

ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin:

#pip requirements
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip python${PYTHON_VERSION}-dev build-essential
RUN apt-get update && \
    python${PYTHON_VERSION} -m pip install --upgrade setuptools
RUN apt-get install --no-install-recommends -y libzmq3-dev
RUN apt install --no-install-recommends -y libffi-dev
RUN python${PYTHON_VERSION} -m pip install wheel 
# RUN python${PYTHON_VERSION} -m pip install pyspark
# RUN python${PYTHON_VERSION} -m pip install avro boto3 kafka-python 
# RUN apt-get install --no-install-recommends -y python3-pip python${PYTHON_VERSION}-dev 
# RUN python${PYTHON_VERSION} -m pip install python-schema-registry-client  
#jupyter notebooks
# RUN python${PYTHON_VERSION} -m pip install ipykernel  
# RUN python${PYTHON_VERSION} -m pip install jupyter
# RUN python${PYTHON_VERSION} -m pip install findspark
##for kakfa-confluent, might be resolved if I can get to higher python version >3.6
# RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/7.0 stable main" \
#     && add-apt-repository "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main" \
#     && apt-get update && apt-get install confluent-platform
# RUN apt-get update && \
#     apt-get install --no-install-recommends -y librdkafka-dev gcc g++
# RUN python${PYTHON_VERSION} -m pip install confluent-kafka
COPY requirements.txt requirements.txt
RUN python${PYTHON_VERSION} -m pip install -r requirements.txt

# spark env
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV SPARK_SCALA_VERSION=${SCALA_VERSION}
ENV SPARK_MASTER_WEBUI_PORT=8080
# pyspark env
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
ENV PYTHONPATH=$SPARK_HOME/python/lib/${PY4J}:$PYTHONPATH
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python${PYTHON_VERSION}
ENV PYSPARK_PYTHON=/usr/bin/python${PYTHON_VERSION}

#LGC DEV
ENV LGC_DEV=TRUE

WORKDIR ${SPARK_HOME}
EXPOSE $SPARK_MASTER_WEBUI_PORT
EXPOSE $SPARK_MASTER_PORT
#spark UI
EXPOSE 4042
#schema registry 
EXPOSE 8081

CMD ["bash"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# commands to start docker container.
# start-master.sh
# start-worker.sh spark://localhost:7077

# check if you need this so that the container does not stop, on kubernetes I have to use this.
# while true ; do sleep 2 ; done
# TODO upgrade ubuntu image from python 3.6 -> 3.8 rather than having both installed. -> need to have pip correctly map to the new version also to avoid needing python -m pip install ABC
