FROM ubuntu:14.04

# Install manylinux1 libraries.
# Thanks to @native-api for the report:
# https://github.com/matthew-brett/multibuild/issues/106
RUN apt-get install -y libice6 libsm6 libgl1-mesa-glx libglib2.0-0

# Script to choose Python version
COPY choose_python.sh /usr/bin/
# Installer script for Pythons 2.7 3.4 3.5 3.6
COPY build_install_pythons.sh /

# Install Pythons 2.7 3.4 3.5 3.6 and matching pips
RUN bash build_install_pythons.sh && rm build_install_pythons.sh

# Run Python selection on way into image
ENTRYPOINT ["/usr/bin/choose_python.sh"]
