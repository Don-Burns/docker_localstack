FROM jenkins/jenkins:lts-jdk11
# set the username and password
ENV JENKINS_USER=admin
ENV JENKINS_PASS=admin
# if we want to install via apt
USER root
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
# Install base utilities
RUN apt-get update && \    
    apt-get install -y wget jq && \    
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*
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
# install jenkins plugins
# following https://github.com/jenkinsci/docker/blob/master/README.md#usage-1
COPY jenkins_plugins.txt /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli -f usr/share/jenkins/plugins.txt
# Skip initial setup and allow local git repos
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true"
# drop back to the regular jenkins user - good practice
# USER jenkins
# RUN conda --version