#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then make a virtualenv from that Python and source it

py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}
PYPY_URL=https://downloads.python.org/pypy
DOWNLOADS_SDIR=downloads

function install_pypy {
    # Installs pypy.org PyPy
    # Parameter $version
    # Version given in major or major.minor or major.minor.micro e.g
    # "3" or "3.7" or "3.7.1".
    # Uses $PLAT
    # sets $PYTHON_EXE variable to python executable

    local version=$1
    case "$PLAT" in
    "x86_64")  if [ -n "$IS_MACOS" ]; then
                   suffix="osx64";
               else
                   suffix="linux64";
               fi;;
    "i686")    suffix="linux32";;
    "ppc64le") suffix="ppc64le";;
    "s390x")    suffix="s390x";;
    "aarch64")  suffix="aarch64";;
    *) echo unknown platform "$PLAT"; exit 1;;
    esac

    # Need to convert pypy-7.2 to pypy2.7-v7.2.0 and pypy3.6-7.3 to pypy3.6-v7.3.0
    local prefix=$(get_pypy_build_prefix $version)
    # since prefix is pypy3.6v7.2 or pypy2.7v7.2, grab the 4th (0-index) letter
    local major=${prefix:4:1}
    # get the pypy version 7.2.0
    local py_version=$(fill_pypy_ver $(echo $version | cut -f2 -d-))

    local py_build=$prefix$py_version-$suffix
    local py_zip=$py_build.tar.bz2
    local zip_path=$DOWNLOADS_SDIR/$py_zip
    mkdir -p $DOWNLOADS_SDIR
    wget -nv $PYPY_URL/${py_zip} -P $DOWNLOADS_SDIR
    untar $zip_path
    # bug/feature: pypy package for pypy3 only has bin/pypy3 :(
    if [ "$major" == "3" ] && [ ! -x "$py_build/bin/pypy" ]; then
        ln $py_build/bin/pypy3 $py_build/bin/pypy
    fi
    PYTHON_EXE=$(realpath $py_build/bin/pypy)
    $PYTHON_EXE -mensurepip
    $PYTHON_EXE -mpip install --upgrade pip setuptools wheel
    if [ "$major" == "3" ] && [ ! -x "$py_build/bin/pip" ]; then
        ln $py_build/bin/pip3 $py_build/bin/pip
    fi
    PIP_CMD=pip
}


# The following also sets PYTHON_EXE and PIP_CMD
if [ "${py_ver:0:4}" == "pypy" ]; then
    # Must be pre-installed, py_ver should be pypy3.6-7.3 or pypy2.7-7.3
    if [ -z "$PLAT" ]; then
        # Use any Python that comes to hand.
        PLAT="$(python -c 'import platform; print(platform.uname()[-1])')"
    fi
    install_pypy $py_ver
    py_bin=$PYTHON_EXE
    impl="$($PYTHON_EXE -c 'import platform; print(platform.python_implementation())')"
    if [ "$impl" != "PyPy" ]; then
        echo failed to install PyPy
        exit 1
    fi
else
    py_bin=/usr/bin/python${py_ver}
    if [ ! -e ${py_bin} ]; then
        py_nodot=$(echo ${py_ver} | awk -F "." '{ print $1$2 }')
        abi_suff=m
        # Python 3.8 and up no longer uses the PYMALLOC 'm' suffix
        # https://github.com/pypa/wheel/pull/303
        if [ ${py_nodot} -ge "38" ]; then
            abi_suff=""
        fi
        opt_bin=/opt/cp${py_nodot}${abi_suff}/bin/python${py_ver}
        if [ ! -e ${opt_bin} ]; then
            echo neither "$py_bin" nor "$opt_bin" found
            exit 1
        fi
        py_bin=$opt_bin
    fi
fi
if [ ! -e ${py_bin} ]; then
    echo something wrong, "$py_bin" not found
    exit 1
fi

/root/.local/bin/virtualenv --python=$py_bin venv
source venv/bin/activate
if [ "$py_ver" == "2.6" ]; then
    # Wheel 0.30 doesn't support Python 2.6
    pip install "wheel<=0.29"
fi

# Carry on as before
$@
