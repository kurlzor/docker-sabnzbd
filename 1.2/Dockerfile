FROM alpine:latest

ENV BUILD_TOOLS="autoconf automake g++ libffi-dev libtbb-dev make linux-headers python-dev openssl-dev"

RUN apk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache \
    ${BUILD_TOOLS} \
    curl git libtbb python unrar unzip p7zip \
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
    && git clone https://github.com/kurlzor/par2tbb.git \
    && cd par2tbb \
    && ./configure \
    && make \
    && make install \
# cleanup
    && apk del ${BUILD_TOOLS} \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

ENV SABNZBD_VERSION=1.2.1

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
