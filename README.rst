##################################################
Ubuntu trusty 32-bit images with Pythons installed
##################################################

Ubuntu trusty (14.04) docker images (32-bit) with Pythons:

* 2.7;
* 3.4;
* 3.5;
* 3.6.

installed via ``apt-get install python2.7-dev`` (etc).

Pip installed for each Python via `get-pip.py
<https://bootstrap.pypa.io/get-pip.py>_`.

Dockerhub won't build these images automatically because of network errors in
the image of form ``socket: Operation not permitted`` even for ``ping``.  So,
this image has to pushed up to dockerhup directly::

    docker build -t matthewbrett/trusty:32 .
    docker push matthewbrett/trusty:32
