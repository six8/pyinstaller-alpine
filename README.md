PyInstaller Alpine
==================

![workflow](https://github.com/six8/pyinstaller/actions/workflows/main.yml/badge.svg)

Docker image that can build single file Python apps with
[PyInstaller](http://pyinstaller.readthedocs.io/) for
[Alpine Linux](http://www.alpinelinux.org/).

Alpine uses [musl](https://www.musl-libc.org/) instead of
[glibc](https://www.gnu.org/software/libc/). The PyInstaller bootloader for
Linux that comes with PyInstaller is made for glibc. This Docker image
builds a bootloader with musl.

This container image also provides a clean way to build PyInstaller apps in
an isolated environment.

Supported architectures
-----------------------

- ARMv7 32-bit (`arm32v7`)
- ARMv8 64-bit (`arm64v8`)
- Linux x86-64 (`amd64`)

Usage
-----

### Building A PyInstaller Package

To build a Python package, run a container with your source
mounted as the current working directory:

    docker run --rm \
        -v "$PWD:$PWD" \
        -w "$PWD" \
        six8/pyinstaller-alpine:alpine3.13-python3.9-pyinstaller4.3 \
        --noconfirm \
        --onefile \
        --log-level DEBUG \
        --clean \
        example.py

If a `requirements.txt` file or a `setup.py` is found in the working directory, it
will automatically be installed with `pip`.

This will output a built app to the `dist` sub-directory in your working
directory. The app can be run on an Alpine OS:

    ./dist/example


### Encrypting Your App

You can use PyInstaller to
[obfuscate your source with encryption](https://pythonhosted.org/PyInstaller/usage.html#encrypting-python-bytecode).
To use a specific key, pass a 16 character string with the `--key {key-string}`
parameter. A non-standard feature of this Docker image is that you can use
`--random-key` to use a random key:

    docker run --rm \
        -v "$PWD:$PWD" \
        -w "$PWD" \
        six8/pyinstaller-alpine:alpine3.13-python3.9-pyinstaller4.3 \
        --onefile \
        --random-key \
        --clean \
        example.py


### Reproducible Build

If you want a [Reproducible Build](https://pythonhosted.org/PyInstaller/advanced-topics.html#creating-a-reproducible-build)
when your source has not changed, you can pass a `PYTHONHASHSEED` env var
for consistent randomization for internal data structures:

    docker run --rm \
        -v "$PWD:$PWD" \
        -w "$PWD" \
        -e PYTHONHASHSEED=42 \
        six8/pyinstaller-alpine:alpine3.13-python3.9-pyinstaller4.3 \
        --onefile \
        --clean \
        example.py

    cksum dist/example | awk '{print $1}'


Building Docker Image
---------------------

If you'd like to build the Docker image yourself:

    ./build.sh
