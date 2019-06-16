#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_PATH=${SCRIPT_PATH}/build
LOG_FILE=${BUILD_PATH}/error.txt
cd ${SCRIPT_PATH}

function log {
    echo "$1" >> ${LOG_FILE}
}

# $1: retcode
# $2: error message
function check_result {
    if [ $1 != 0 ]; then
        log "$2"
        exit $1
    fi
}

VER=3.7.3

# decompress source
SRC_PATH=${SCRIPT_PATH}/Python-${VER}
if [ -d ${SRC_PATH} ]; then
    rm -r ${SRC_PATH}
fi
tar xvf Python-${VER}.tar.xz

# prepare build path
if [ -d ${BUILD_PATH} ]; then
    rm -r ${BUILD_PATH}
fi
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# configure
log "-- configure"
${SRC_PATH}/configure --enable-optimizations --with-lto 2>>${LOG_FILE}
result=$?
check_result ${result} "-- configure failed"

# make
log ""
log "-- make"
make -j4 2>>${LOG_FILE}
result=$?
check_result ${result} "-- make failed"

# install
log ""
log "-- install"
sudo make install 2>>${LOG_FILE}
result=$?
check_result ${result} "-- install failed"

# ln
sudo ln -s /usr/lib/python3/dist-packages/CommandNotFound/ /usr/local/lib/python3.7
sudo ln -s /usr/lib/python3/dist-packages/lsb_release.py /usr/local/lib/python3.7
sudo ln -s /usr/lib/python3/dist-packages/apt_pkg.cpython-36m-x86_64-linux-gnu.so /usr/local/lib/python3.7/apt_pkg.cpython-37m-x86_64-linux-gnu.so

# python3 -> python3.7
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 100
sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 200
# python -> python3
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 100
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 150
