FROM python:3.7-slim-bullseye

ENV LANG C.UFT-8

# install gen stuff
RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    wget \
    zip
# aws cli
RUN apt update && apt install -y unzip curl \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN apt update && pip install awscli-local

# requirements
COPY ./src/requirements.txt ./requirements.txt
RUN apt update && \
    pip install -r requirements.txt


ENTRYPOINT [ "bash","-c" ]
CMD [ "while sleep 1000; do :; done" ]