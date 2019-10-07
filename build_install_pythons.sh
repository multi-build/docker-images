#!/bin/bash
# Install Pythons 2.7 3.4 3.5 3.6 3.7 3.8rc1 and matching pips
set -ex

echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6A755776
apt-get update
apt-get install -y wget
PIP_ROOT_URL="https://bootstrap.pypa.io"
wget $PIP_ROOT_URL/get-pip.py
for pyver in 3.4 3.5 3.6 2.7 2.6 3.3 ; do
    pybin=python$pyver
    apt-get install -y ${pybin}-dev ${pybin}-tk
    get_pip_fname="get-pip.py"
    for badver in 2.6 3.3 ; do
        if [ "$pyver" == "$badver" ]; then
            get_pip_fname="get-pip-${pyver}.py"
            wget $PIP_ROOT_URL/${pyver}/get-pip.py -O $get_pip_fname
        fi
    done
    ${pybin} ${get_pip_fname}
done

# Get virtualenv for Python 3.5
pip3.5 install --user virtualenv

BUILD_PKGS="zlib1g-dev libbz2-dev libncurses5-dev libreadline-gplv2-dev \
    libsqlite3-dev libssl-dev libgdbm-dev tcl-dev tk-dev \
    libffi-dev liblzma-dev uuid-dev"
apt-get -y install build-essential $BUILD_PKGS

function compile_python {
    local py_ver="$1"
    local extra_args="$2"
    local froot="Python-${py_ver}"
    local ftgz="${froot}.tgz"
    wget https://www.python.org/ftp/python/${py_ver}/${ftgz}
    tar zxf ${ftgz}
    local py_nodot=$(echo ${py_ver} | awk -F "." '{ print $1$2 }')
    local abi_suff=m
    # Python 3.8 and up no longer uses the PYMALLOC 'm' suffix
    # https://github.com/pypa/wheel/pull/303
    if [ ${py_nodot} -ge "38" ]; then
        abi_suff=""
    fi
    local out_root=/opt/cp${py_nodot}${abi_suff}
    mkdir $out_root
    (cd Python-${py_ver} \
        && ./configure --prefix=$out_root ${extra_args} \
        && make \
        && make install)
    # Remove stray files
    rm -rf ${froot} ${ftgz}
}

# Compile narrow unicode Python
# Compiled Pythons need to be flagged in the choose_python.sh script.
compile_python 2.7.11 "--enable-unicode=ucs2"
# Get pip for narrow unicode Python
/opt/cp27m/bin/python get-pip.py

# Compile Python 3.7.0, pip comes along with.
# Python 3.7 from deadsnakes does not appear to have SSL.
# Compilation needs SSL 1.0.2, not available for Trusty.
function build_openssl {
    local version=$1
    local froot="openssl-${version}"
    local ftgz="${froot}.tar.gz"
    wget https://www.openssl.org/source/${ftgz}
    tar xvf ${ftgz}
    (cd $froot &&
    ./config no-ssl2 no-shared -fPIC --prefix=/usr/local/ssl &&
    make &&
    make install)
    rm -rf ${froot} ${ftgz}
}

build_openssl 1.0.2o
# Compiled Pythons need to be flagged in the choose_python.sh script.
compile_python 3.7.0 "--with-openssl=/usr/local/ssl"
compile_python 3.8.0rc1 "--with-openssl=/usr/local/ssl"

# Install certificates from certifi, for Python 3.7
# Thanks to Github user Mr BitBucket for this fix.
# Make virtuelenv for certifi install.
/root/.local/bin/virtualenv --python=/opt/cp37m/bin/python3 venv
. venv/bin/activate
# Install certifi and copy .pem file to system locaation.
pip install certifi
CERTIFI_CERT=$(python -c "import certifi; print(certifi.where())")
DEFAULT_CERT=$(python -c"import ssl; print(ssl.get_default_verify_paths().openssl_cafile)")
echo "CERTIFI_CERT=$CERTIFI_CERT"
echo "DEFAULT_CERT=$DEFAULT_CERT"
cp ${CERTIFI_CERT} ${DEFAULT_CERT}
deactivate
# Remove virtualenv files from image
rm -rf venv

# Clean out not-needed packages
apt-get -y remove $BUILD_PKGS
apt-get -y autoremove
apt-get clean

# Remove stray files
rm -f get-pip*.py
