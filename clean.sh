#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for build in `find ${SCRIPT_PATH} -name "build" -type d`
do
    if [ -d ${build} ]; then
        rm -rf ${build}
        echo removed ${build}
    fi
done
