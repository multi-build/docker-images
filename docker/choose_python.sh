#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then make a virtualenv from that Python and source it
set -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}

# The following also sets PYTHON_EXE and PIP_CMD
if [ "${PYTHON_VERSION:0:4}" == "pypy" ]; then
    source /io/common_utils.sh
    if [ -z "$PLAT" ]; then
        PLAT="$(get_platform)"
    fi
    # TODO: pre-install some versions of PyPy.
    pushd /io
    install_pypy $PYTHON_VERSION
    popd
    py_bin=$PYTHON_EXE
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
    fi
    if [ ! -e ${opt_bin} ]; then
        echo neither "$py_bin" nor "$opt_bin" found
        exit 1
    fi
    py_bin=$opt_bin
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
