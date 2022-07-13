FROM python:3.7-slim-bullseye

ENV LANG C.UFT-8

ARG SCALA_VERSION=2.12
ARG SPARK_VERSION=3.1.2
ARG HADOOP_VERSION=3.2
ARG PYTHON_VERSION=3.7

# install gen stuff
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    wget

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

# spark env
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV SPARK_SCALA_VERSION=${SCALA_VERSION}
ENV SPARK_MASTER_WEBUI_PORT=8080
# pyspark env
#link to the python version use in /usr/local/bin in base image
RUN ln -s /usr/local/bin/python /usr/bin/python${PYTHON_VERSION}
# RUN export PYTHONPATH=${SPARK_HOME}/python/:$(echo ${SPARK_HOME}/python/lib/py4j-*-src.zip):${PYTHONPATH}
ARG PY4J=py4j-0.10.9-src.zip
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
ENV PYTHONPATH=$SPARK_HOME/python/lib/${PY4J}:$PYTHONPATH
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python${PYTHON_VERSION}
ENV PYSPARK_PYTHON=/usr/bin/python${PYTHON_VERSION}

RUN pip install ipykernel
#LGC DEV
ENV LGC_DEV=TRUE
# aws cli
RUN apt update && apt install -y unzip curl \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

# get redshift jdbc jar
WORKDIR ${SPARK_HOME}/jars
RUN wget https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/1.2.55.1083/RedshiftJDBC42-no-awssdk-1.2.55.1083.jar

#install python dependencies from Pipfile
RUN pip install pipenv
COPY ./Pipfile ./Pipfile
COPY ./Pipfile.lock ./Pipfile.lock
RUN apt update && \
    pipenv lock --keep-outdated -d -r > requirements.txt && \
    pip install -r requirements.txt
# install minicoda and conda-pack
# ENV CONDA_DIR /opt/conda
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
# RUN bash ~/miniconda.sh -b -p /opt/conda
# # Put conda in path so we can use conda 
# ENV PATH=$CONDA_DIR/bin:$PATH
# # set conda python version to match spark
# RUN conda install python=$PYTHON_VERSION
# # add conda pack
# RUN conda install -y conda-pack

WORKDIR ${SPARK_HOME}
EXPOSE $SPARK_MASTER_WEBUI_PORT
EXPOSE $SPARK_MASTER_PORT
#spark UI
EXPOSE 4042
#schema registry 
EXPOSE 8081
# local runner flag
ENV is_local="TRUE"

ENTRYPOINT [ "bash","-c" ]
CMD [ "while sleep 1000; do :; done" ]
# CMD [ "echo hello" ]
