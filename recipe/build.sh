#!/usr/bin/env bash

if [[ "$target_platform" == osx-* ]]; then
    export ENABLE_BACKTRACE=no
    # Workarounds for missing C++17 features.
    export CXXFLAGS="$CXXFLAGS -DCATCH_CONFIG_NO_CPP17_UNCAUGHT_EXCEPTIONS -fno-aligned-allocation"
else
    LDFLAGS="-lrt ${LDFLAGS}"
    export ENABLE_BACKTRACE=yes
fi

mkdir build
cd build

cmake ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DOBAKE_BUILD_TESTS=yes \
    -DOBAKE_INSTALL_LIBDIR=lib \
    -DOBAKE_WITH_LIBBACKTRACE=$ENABLE_BACKTRACE \
    ..

make -j${CPU_COUNT} VERBOSE=1

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure -j${CPU_COUNT}
fi

make install
