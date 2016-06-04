FROM alpine:latest

ENV BUILD_TOOLS="autoconf automake g++ libffi-dev make linux-headers python-dev openssl-dev" PAR2CMDLINE_VERSION=v0.6.14

RUN apk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
    ${BUILD_TOOLS} \
    curl git python unrar unzip p7zip \
# pip
    && cd /tmp \
    && curl https://bootstrap.pypa.io/get-pip.py > pip.py \
    && python pip.py \
## Python modules
    && pip install --upgrade cffi cheetah pyOpenSSL pydbus support \
    && cd /tmp \
    && curl -O http://www.golug.it/pub/yenc/yenc-0.4.0.tar.gz \
    && tar xzfv yenc-0.4.0.tar.gz \
    && cd yenc-0.4.0 \
    && python setup.py build \
    && python setup.py install \
# par2cmdline
    && cd /tmp \
    && curl -o par2cmdline.tar.gz https://codeload.github.com/Parchive/par2cmdline/tar.gz/${PAR2CMDLINE_VERSION} \
    && tar xzfv par2cmdline.tar.gz \
    && cd par2cmdline-* \
    && aclocal \
    && automake --add-missing \
    && autoconf \
    && ./configure \
    && make \
    && make install \
# cleanup
    && apk del ${BUILD_TOOLS} \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

ENV SABNZBD_VERSION=1.0.3

# sabnzbd
RUN cd /tmp \
    && curl -Lo sabnzbd.tar.gz https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz \
    && tar xzfv sabnzbd.tar.gz \
    && mv SABnzbd-* /sabnzbd \
    && rm sabnzbd.tar.gz

# Exposing sabnzbd web ui
EXPOSE 8080

# Define container volume
VOLUME ["/config", "/downloads"]

# Define environement variables, this is a hack since SABnzbd will store
# its configuration in ~/.sabnzbd
ENV HOME /config

# Setting start CMD
CMD ["/usr/bin/python", "/sabnzbd/SABnzbd.py", "-f", "/config/sabnzbd.ini", "-s", "0.0.0.0:8080"]