FROM ubuntu:14.04

# enable the universe
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list

# Install Pythons 2.7 3.4 3.5 and matching pips
COPY build_install_pythons.sh /
RUN bash build_install_pythons.sh && rm build_install_pythons.sh
# Script to choose Python version
COPY choose_python.sh /usr/bin

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
