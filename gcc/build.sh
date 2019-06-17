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

VER=9.1.0
SUFFIX=-last

# prepare build path
if [ -d ${BUILD_PATH} ]; then
    rm -rf ${BUILD_PATH}
fi
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# decompress source
SRC_PATH=${BUILD_PATH}/gcc-${VER}

tar xvf ${SCRIPT_PATH}/gcc-${VER}.tar.xz

tar xvf ${SCRIPT_PATH}/gmp-6.1.0.tar.bz2
mv gmp-6.1.0 ${SRC_PATH}/gmp

tar xvf ${SCRIPT_PATH}/mpc-1.0.3.tar.gz
mv mpc-1.0.3 ${SRC_PATH}/mpc

tar xvf ${SCRIPT_PATH}/mpfr-3.1.4.tar.bz2
mv mpfr-3.1.4 ${SRC_PATH}/mpfr

# tar xvf ${SCRIPT_PATH}/isl-0.18.tar.bz2
# mv isl-0.18 ${SRC_PATH}/isl

BUILD_PATH=${BUILD_PATH}/build
mkdir ${BUILD_PATH}
cd ${BUILD_PATH}

# configure
log "-- configure"
${SRC_PATH}/configure \
    --build=x86_64-pc-linux-gnu \
    --host=x86_64-pc-linux-gnu \
    --target=x86_64-pc-linux-gnu \
    --prefix=/usr/local/gcc${SUFFIX} \
    --program-suffix=${SUFFIX} \
    --enable-languages=c,c++ \
    --enable-multilib \
    --enable-threads \
    2>>${LOG_FILE}
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

libtool --finish /usr/local/gcc-last/libexec/gcc/x86_64-pc-linux-gnu/9.1.0

sudo ln -s /usr/local/gcc-last/bin/c++-last /usr/bin/c++-last
sudo ln -s /usr/local/gcc-last/bin/cpp-last /usr/bin/cpp-last
sudo ln -s /usr/local/gcc-last/bin/gcc-ar-last /usr/bin/gcc-ar-last
sudo ln -s /usr/local/gcc-last/bin/gcc-last /usr/bin/gcc-last
sudo ln -s /usr/local/gcc-last/bin/gcc-nm-last /usr/bin/gcc-nm-last
sudo ln -s /usr/local/gcc-last/bin/gcc-ranlib-last /usr/bin/gcc-ranlib-last
sudo ln -s /usr/local/gcc-last/bin/gcov-dump-last /usr/bin/gcov-dump-last
sudo ln -s /usr/local/gcc-last/bin/gcov-last /usr/bin/gcov-last
sudo ln -s /usr/local/gcc-last/bin/gcov-tool-last /usr/bin/gcov-tool-last
sudo ln -s /usr/local/gcc-last/bin/g++-last /usr/bin/g++-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-c++-last /usr/bin/x86_64-pc-linux-gnu-c++-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-gcc-9.1.0 /usr/bin/x86_64-pc-linux-gnu-gcc-9.1.0
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-gcc-ar-last /usr/bin/x86_64-pc-linux-gnu-gcc-ar-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-gcc-last /usr/bin/x86_64-pc-linux-gnu-gcc-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-gcc-nm-last /usr/bin/x86_64-pc-linux-gnu-gcc-nm-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-gcc-ranlib-last /usr/bin/x86_64-pc-linux-gnu-gcc-ranlib-last
sudo ln -s /usr/local/gcc-last/bin/x86_64-pc-linux-gnu-g++-last /usr/bin/x86_64-pc-linux-gnu-g++-last
