#!/bin/bash
# Install Pythons 2.7 3.4 3.5 and matching pips
set -e

echo "deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C
apt-get update
apt-get install -y wget
wget https://bootstrap.pypa.io/get-pip.py
for pyver in 3.4 3.5 2.6 2.7 3.3 ; do
    pybin=python$pyver
    apt-get install -y ${pybin}-dev ${pybin}-tk
    ${pybin} get-pip.py
done

# Get virtualenv for Python 3.5
pip3.5 install --user virtualenv

# Compile narrow unicode Python
BUILD_PKGS="zlib1g-dev libbz2-dev libncurses5-dev libreadline-gplv2-dev \
    libsqlite3-dev libssl-dev libgdbm-dev tcl-dev tk-dev"
apt-get -y install build-essential $BUILD_PKGS
wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
tar zxf Python-2.7.11.tgz
OUT_ROOT=/opt/cp27m
mkdir $OUT_ROOT
(cd Python-2.7.11 \
    && ./configure --prefix=$OUT_ROOT --enable-unicode=ucs2 \
    && make \
    && make install)

# Get pip for narrow unicode Python
$OUT_ROOT/bin/python get-pip.py

# Clean out not-needed packages
apt-get -y remove $BUILD_PKGS
apt-get -y autoremove
apt-get clean

# Remove stray files
rm -rf Python-2.7* get-pip.py
