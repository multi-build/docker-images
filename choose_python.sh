#!/bin/bash
# Choose python from PYTHON_VERSION, UNICODE_WIDTH
# Then execute whatever the user put on the command line
py_ver=${PYTHON_VERSION:-3.5}
uc_width=${UNICODE_WIDTH:-32}

if [ "$py_ver" == "2.7" ] && [ "$uc_width" == "16" ]; then
    py_bin_dir=/opt/cp27m/bin
    pip_bin_dir=$py_bin_dir
else
    py_bin_dir=/usr/bin
    pip_bin_dir=/usr/local/bin
fi
ln -sf $py_bin_dir/python$py_ver /usr/bin/python
ln -sf $pip_bin_dir/pip$py_ver /usr/local/bin/pip

# Carry on as before
$@
