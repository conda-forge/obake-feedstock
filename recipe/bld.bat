mkdir build
cd build

cmake ^
    -G "Ninja" ^
    -DCMAKE_C_COMPILER=clang-cl ^
    -DCMAKE_CXX_COMPILER=clang-cl ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    -DOBAKE_BUILD_TESTS=yes ^
    ..

cmake --build . -- -v

set PATH=%PATH%;%CD%

ctest --output-on-failure -j${CPU_COUNT}

cmake --build . --target install
