#!/usr/bin/env bash

COREUTILS_VER=8.30

# Download coreutils and patch
wget https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VER}.tar.xz
if [[ $? == 5 ]]; then
    echo "Try using --ca-certificate= or --no-check-certificate with wget."
fi
tar -xf coreutils-${COREUTILS_VER}.tar.xz
rm coreutils-${COREUTILS_VER}.tar.xz
cd coreutils-${COREUTILS_VER} || exit 1
patch -p0 < ../ls.patch

# Compile and copy binaries
./configure

if ! make; then
    if [[ "$(uname -s)" == "Darwin"* ]]; then
        echo "If make fails with a message like this:"
        echo "...built for archive which is not the architecture being linked (x86_64)"
        echo "Try \"brew unlink binutils\" and run script again."
    fi
fi

# copy the new executable
if [[ ! -e "/usr/local/bin/lsi" ]]; then
    mv src/ls /usr/local/bin/lsi
    echo "New executable 'lsi' installed to /usr/local/bin"
    echo "Make sure this is in your PATH."
    echo "Use something like \"alias ls='lsi'\" to use lsi in place of ls."
    cd ../ || exit 1
    rm -rf coreutils-${COREUTILS_VER}
else
    echo "ERROR: lsi already exists in /usr/local/bin" >&2
    exit 1
fi
