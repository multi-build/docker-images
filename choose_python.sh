#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then make a virtualenv from that Python and source it
py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}

if [ "$py_ver" == "2.7" ] && [ "$uc_width" == "16" ]; then
    py_bin=/opt/cp27m/bin/python$py_ver
elif [ "$py_ver" == "3.6" ]; then
    py_bin=/opt/cp36m/bin/python$py_ver
else
    py_bin=/usr/bin/python$py_ver
fi
/root/.local/bin/virtualenv --python=$py_bin venv
source venv/bin/activate

# Carry on as before
$@
