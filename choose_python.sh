#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then make a virtualenv from that Python and source it
set -x

py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}

# The following also sets PYTHON_EXE and PIP_CMD
if [ "${PYTHON_VERSION:0:4}" == "pypy" ]; then
  source /io/common_utils.sh
  # TODO: pre-install some versions of PyPy.
  install_pypy $PYTHON_VERSION
  py_bin=$PYTHON_EXE
else
    py_nodot=$(echo ${py_ver} | awk -F "." '{ print $1$2 }')
    if [ "$py_ver" == "2.7" ] && [ "$uc_width" == "16" ] \
        || [ ${py_nodot} -ge "39" ]; then
        abi_suff=m
        # Python 3.8 and up no longer uses the PYMALLOC 'm' suffix
        # https://github.com/pypa/wheel/pull/303
        if [ ${py_nodot} -ge "38" ]; then
            abi_suff=""
        fi
        py_bin=/opt/cp${py_nodot}${abi_suff}/bin/python${py_ver}
    else
        py_bin=/usr/bin/python${py_ver}
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
