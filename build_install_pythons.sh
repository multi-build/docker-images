#!/bin/bash
# Install Pythons 2.7 3.4 3.5 3.6 and matching pips
set -e

echo "deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C
apt-get update
apt-get install -y wget
wget https://bootstrap.pypa.io/get-pip.py
for pyver in 3.4 3.5 3.6 2.6 2.7 3.3 ; do
    pybin=python$pyver
    apt-get install -y ${pybin}-dev ${pybin}-tk
    ${pybin} get-pip.py
done

# Get virtualenv for Python 3.5
pip3.5 install --user virtualenv

BUILD_PKGS="zlib1g-dev libbz2-dev libncurses5-dev libreadline-gplv2-dev \
    libsqlite3-dev libssl-dev libgdbm-dev tcl-dev tk-dev \
    libffi-dev"
apt-get -y install build-essential $BUILD_PKGS

# currently unused
function compile_python {
    local py_ver="$1"
    local extra_args="$2"
    wget https://www.python.org/ftp/python/${py_ver}/Python-${py_ver}.tgz
    tar zxf Python-${py_ver}.tgz
    local py_nodot=$(echo ${py_ver} | awk -F "." '{ print $1$2 }')
    local out_root=/opt/cp${py_nodot}m
    mkdir $out_root
    (cd Python-${py_ver} \
        && ./configure --prefix=$out_root ${extra_args} \
        && make \
        && make install)
}

# Compile narrow unicode Python
compile_python 2.7.11 "--enable-unicode=ucs2"
# Get pip for narrow unicode Python
/opt/cp27m/bin/python get-pip.py

# Compile Python 3.7.0, pip comes along with.
compile_python 3.7.0

# Clean out not-needed packages
apt-get -y remove $BUILD_PKGS
apt-get -y autoremove
apt-get clean

# Remove stray files
rm -rf Python-2.7* get-pip.py
