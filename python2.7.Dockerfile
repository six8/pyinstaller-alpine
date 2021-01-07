ARG ARCH=""
ARG ALPINE_VERSION="3.12"

# Using Alpine as base image 
FROM alpine:${ALPINE_VERSION}

ARG PYINSTALLER_TAG
ENV PYINSTALLER_TAG ${PYINSTALLER_TAG:-"v3.6"}

# PyInstaller needs zlib-dev, gcc, libc-dev, and musl-dev
RUN apk --update --no-cache add \
    zlib-dev \
    musl-dev \
    libc-dev \
    libffi-dev \
    gcc \
    g++ \
    git \
    pwgen \
    python2 \
    python2-dev

#install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && pip --version && rm get-pip.py && pip install -U pip

# Install pycrypto so --key can be used with PyInstaller
RUN pip install \
    pycrypto

# Build bootloader for alpine
RUN git clone --depth 1 --single-branch --branch ${PYINSTALLER_TAG} https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all \
    && pip install .. \
    && rm -Rf /tmp/pyinstaller

VOLUME /src
WORKDIR /src

ADD ./bin /pyinstaller
RUN chmod a+x /pyinstaller/*

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]
