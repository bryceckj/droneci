FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
# Install main dependencies
RUN apt-get -y update && \
    apt-get -y install git && \
    apt-get install -y gnupg2 && \
    apt-get -y install curl

# Install pip, awscli
RUN apt-get -y install python && \
    curl -k https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install awscli yq
# # Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# Install R -note: can remove
RUN apt-get -y update && \
    apt-get -y install gdebi-core && \
    curl -k -O https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-3.6.3_1_amd64.deb && \
    yes | gdebi r-3.6.3_1_amd64.deb


# docker build . -t droner:demo
# docker tag droner:demo brycechong/droner:demo
# docker push brycechong/droner:demo 