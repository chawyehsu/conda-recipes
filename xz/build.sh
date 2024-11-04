#!/bin/bash

cmake $CMAKE_ARGS ^
    -G Ninja ^
    -B build ^
    -D BUILD_SHARED_LIBS=YES ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D CMAKE_INSTALL_PREFIX=$LIBRARY_PREFIX ^
    -D CMAKE_PREFIX_PATH=$LIBRARY_PREFIX ^
    -S $SRC_DIR

cmake --build build -j $CPU_COUNT --target install
