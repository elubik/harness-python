FROM python:3.12.4-alpine
MAINTAINER Emil Lubikowski <e.lubikowski@gmail.com>

# Run CA certificates update
RUN apk update && apk add ca-certificates
# The certifi package provides a bundle of CA certificates for Python.
# Let us ensure certifi is installed and up to date.
RUN pip install --upgrade certifi

RUN pip install --upgrade pip setuptools wheel
# These are copied and installed first in order to take maximum advantage
# of Docker layer caching (if enabled).
COPY *requirements.txt /opt/app/src/
RUN pip install -r /opt/app/src/requirements.txt
RUN pip install -r /opt/app/src/test-requirements.txt

COPY . /opt/app/src/
WORKDIR /opt/app/src
RUN python setup.py install

EXPOSE 5000
CMD dronedemo
