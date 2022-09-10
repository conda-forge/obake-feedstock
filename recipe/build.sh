#!/usr/bin/env bash

LDFLAGS="-lrt ${LDFLAGS}"
export ENABLE_BACKTRACE=yes

mkdir build
cd build

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DOBAKE_BUILD_TESTS=yes \
    -DOBAKE_INSTALL_LIBDIR=lib \
    -DOBAKE_WITH_LIBBACKTRACE=$ENABLE_BACKTRACE \
    -DBoost_NO_BOOST_CMAKE=ON \
    ..

make -j${CPU_COUNT} VERBOSE=1

ctest --output-on-failure -j${CPU_COUNT}

make install
