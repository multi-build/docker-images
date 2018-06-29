#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then make a virtualenv from that Python and source it
py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}

if [ "$py_ver" == "2.7" ] && [ "$uc_width" == "16" ] \
    || [ "$py_ver" == "3.7" ]; then
    py_nodot=$(echo ${py_ver} | awk -F "." '{ print $1$2 }')
    py_bin=/opt/cp${py_nodot}m/bin/python$py_ver
else
    py_bin=/usr/bin/python$py_ver
fi
/root/.local/bin/virtualenv --python=$py_bin venv
source venv/bin/activate
if [ "$py_ver" == "2.6" ]; then
    # Wheel 0.30 doesn't support Python 2.6
    pip install "wheel<=0.29"
fi

# Carry on as before
$@
