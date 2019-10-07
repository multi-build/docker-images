##################################################
Ubuntu trusty 32-bit images with Pythons installed
##################################################

Ubuntu trusty (14.04) docker images (32-bit) with Pythons:

* 2.7;
* 3.4;
* 3.5;
* 3.6;
* 3.7;
* 3.8.0rc1

installed via ``apt-get install python2.7-dev`` (etc).

Pip installed for each Python via `get-pip.py
<https://bootstrap.pypa.io/get-pip.py>`_.

Pythons 3.7, 3.8rc1 are installed from source. They include pip and setuptools.

Dockerhub won't build these images automatically because of network errors in
the image of form ``socket: Operation not permitted`` even for ``ping``.  So,
this image has to be pushed up to dockerhub directly::

    docker build -t matthewbrett/trusty:32 .
    docker login --username=matthewbrett
    docker push matthewbrett/trusty:32

If you get a "User interaction is not allowed." error at the ``login`` stage,
you may get further by running this command at the affected terminal::

   security unlock-keychain

See
https://github.com/docker/docker-credential-helpers/issues/82#issuecomment-367258282
