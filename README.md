PyInstaller Alpine
==================

Docker image that can build single file Python apps with
[PyInstaller](http://pyinstaller.readthedocs.io/) for
[Alpine Linux](http://www.alpinelinux.org/).

Alpine uses [musl](https://www.musl-libc.org/) instead of
[glibc](https://www.gnu.org/software/libc/). The PyInstaller bootloader for
Linux 64 that comes with PyInstaller is made for glibc. This Docker image
builds a bootloader with musl.

This Docker image also provides a clean way to build PyInstaller apps in
an isolated environment.

Usage
-----

### Building A PyInstaller Package

To build a Python package, create a Docker container with your source
mounted as a volume at `/src`:

    docker run --rm \
        -v "${PWD}:/src" \
        six8/pyinstaller-alpine \
        --noconfirm \
        --onefile \
        --log-level DEBUG \
        --clean \
        example.py

If a `requirements.txt` file is found in your source directory, the
requirements will automatically be installed with `pip`.

This will output a built app to the `dist` sub-directory in your source
directory. The app can be ran on an Alpine OS:

    ./dist/example


### Encrypting Your App

You can use PyInstaller to
[obfuscate your source with encryption](https://pythonhosted.org/PyInstaller/usage.html#encrypting-python-bytecode).
To use a specific key, pass a 16 character string with the `--key {key-string}`
parameter. A non-standard feature of this Docker image is that you can use
`--random-key` to use a random key:

    docker run --rm \
        -v "${PWD}:/src" \
        six8/pyinstaller-alpine \
        --onefile \
        --random-key \
        --clean \
        example.py


### Reproducible Build

If you want a [Reproducible Build](https://pythonhosted.org/PyInstaller/advanced-topics.html#creating-a-reproducible-build)
when your source has not changed, you can pass a `PYTHONHASHSEED` env var
for consistent randomization for internal data structures:

    docker run --rm \
        -v "${PWD}:/src" \
        -e PYTHONHASHSEED=42 \
        six8/pyinstaller-alpine \
        --onefile \
        --clean \
        example.py

    cksum dist/example | awk '{print $1}'


Building Docker Image
---------------------

If you'd like to build the Docker image yourself:

    ./build.sh
