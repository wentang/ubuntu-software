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

VER=8.0.0

# prepare build path
if [ -d ${BUILD_PATH} ]; then
    rm -r ${BUILD_PATH}
fi
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# decompress source
SRC_PATH=${BUILD_PATH}/llvm-${VER}.src
tar xvf ${SCRIPT_PATH}/llvm-${VER}.src.tar.xz

tar xvf ${SCRIPT_PATH}/cfe-${VER}.src.tar.xz
mv cfe-${VER}.src ${SRC_PATH}/tools/clang

tar xvf ${SCRIPT_PATH}/clang-tools-extra-${VER}.src.tar.xz
mv clang-tools-extra-${VER}.src ${SRC_PATH}/tools/clang/tools/extra

tar xvf ${SCRIPT_PATH}/compiler-rt-${VER}.src.tar.xz
mv compiler-rt-${VER}.src ${SRC_PATH}/projects/compiler-rt

BUILD_PATH=${BUILD_PATH}/build
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# configure
log "-- configure"
cmake -DCMAKE_BUILD_TYPE=Release ${SRC_PATH} 2>>${LOG_FILE}
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
