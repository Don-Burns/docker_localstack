FROM jenkins/jenkins:lts-jdk11
# if we want to install via apt
USER root
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update && apt-get install -y wget
# aws cli
RUN apt-get update && \
    apt-get install -y wget zip gnupg software-properties-common curl && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install
# conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh
RUN apt update && conda install -y conda-pack
# give permissions to jenkins user
RUN chmod 777 -R /root/miniconda3
RUN conda --version
# drop back to the regular jenkins user - good practice
# USER jenkins
# RUN conda --version