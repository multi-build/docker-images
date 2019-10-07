##################################################
Ubuntu trusty 64-bit images with Pythons installed
##################################################

Ubuntu trusty (14.04) docker images (64-bit) with Pythons:

* 2.7;
* 3.4;
* 3.5;
* 3.6

installed via ``apt-get install python2.7-dev`` (etc).

Pip installed for each Python via `get-pip.py
<https://bootstrap.pypa.io/get-pip.py>`_.

Pythons 3.7, 3.8rc1 are installed from source. They include pip and setuptools.

Dockerhub builds this image automatically on push to Github.
