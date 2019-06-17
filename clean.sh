#!/bin/bash

for build in `find -name "build" -type d`
do
    if [ -d ${build} ]; then
        rm -rf ${build}
        echo removed ${build}
    fi
done
