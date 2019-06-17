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
    if [ "$1" != "0" ]; then
        log "$2"
        exit $1
    fi
}

VER=3.14.5

# prepare build path
if [ -d ${BUILD_PATH} ]; then
    rm -r ${BUILD_PATH}
fi
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# decompress source
SRC_PATH=${BUILD_PATH}/cmake-${VER}
tar xvf ${SCRIPT_PATH}/cmake-${VER}.tar.gz

BUILD_PATH=${BUILD_PATH}/build
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# bootstrap
log "-- bootstrap"
${SRC_PATH}/bootstrap 2>>${LOG_FILE}
result=$?
check_result ${result} "-- bootstrap failed"

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
