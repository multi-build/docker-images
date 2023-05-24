#!/bin/bash
# Install Pythons 2.7 3.6 3.7 3.8 3.9 3.10 3.11 3.12 and matching pips
set -ex

echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main" > /etc/apt/sources.list.d/deadsnakes.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A755776
apt-get update
apt-get install -y wget
PIP_ROOT_URL="https://bootstrap.pypa.io"
for pyver in 2.7; do
    pybin=python$pyver
    apt install -y ${pybin} ${pybin}-dev ${pybin}-tk
    wget $PIP_ROOT_URL/pip/$pyver/get-pip.py -O get-pip-$pyver.py
    get_pip_fname="get-pip-${pyver}.py"
    ${pybin} ${get_pip_fname}
done
for pyver in 3.6; do
    pybin=python$pyver
    apt install -y ${pybin} ${pybin}-dev ${pybin}-tk ${pybin}-distutils
    wget $PIP_ROOT_URL/pip/$pyver/get-pip.py -O get-pip-$pyver.py
    get_pip_fname="get-pip-${pyver}.py"
    ${pybin} ${get_pip_fname}
done
wget $PIP_ROOT_URL/get-pip.py
for pyver in 3.7 3.8 3.9 3.10 3.11 3.12; do
    pybin=python$pyver
    apt install -y ${pybin} ${pybin}-dev ${pybin}-tk ${pybin}-distutils
    get_pip_fname="get-pip.py"
    ${pybin} ${get_pip_fname}
done
BUILD_PKGS="zlib1g-dev libbz2-dev libncurses5-dev libreadline-gplv2-dev \
    libsqlite3-dev libssl-dev libgdbm-dev tcl-dev tk-dev \
    liblzma-dev uuid-dev"
apt-get -y install build-essential $BUILD_PKGS libffi-dev

# Clean out not-needed packages
apt -y remove $BUILD_PKGS
apt -y autoremove
apt clean

# Remove stray files
rm -f get-pip*.py
