FROM ubuntu:14.04

# enable the universe
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

# Install Pythons 2.7 3.4 3.5 and matching pips
RUN echo "deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list \
    && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C \
    && apt-get update \
    && apt-get install -y wget \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && for pyver in 3.4 3.5 2.7; do \
           apt-get install -y python$pyver-dev; \
           python$pyver get-pip.py; \
       done;

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
