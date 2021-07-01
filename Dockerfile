ARG ALPINE_VERSION
ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS base

ARG PYINSTALLER_TAG

# Official Python base image is needed or some applications will segfault.
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
    && pip install --upgrade pip

# Install pycrypto so --key can be used with PyInstaller
RUN pip install \
    pycrypto

FROM base AS bootloader

ARG SOURCE_REF
ARG SOURCE_COMMIT

# Build bootloader for alpine
ADD https://github.com/pyinstaller/pyinstaller/archive/refs/tags/${PYINSTALLER_TAG}.tar.gz /tmp/${PYINSTALLER_TAG}.tar.gz
RUN mkdir -p /pyinstaller \
    && cd /pyinstaller && tar --strip-components=1 -zxf /tmp/${PYINSTALLER_TAG}.tar.gz
RUN cd /pyinstaller/bootloader \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all
RUN cd /pyinstaller \
    && python setup.py bdist_wheel

FROM base

COPY --from="bootloader" /pyinstaller/dist/*.whl /wheels/
RUN cd /wheels && pip install *.whl

VOLUME /src
WORKDIR /src

ADD ./bin /pyinstaller
RUN chmod a+x /pyinstaller/*

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="pyinstaller-alpine"
LABEL org.label-schema.vcs-ref="${SOURCE_REF}:${SOURCE_COMMIT}"
LABEL org.label-schema.vcs-url="https://github.com/six8/pyinstaller-alpine"
