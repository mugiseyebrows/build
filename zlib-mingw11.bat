@echo off
rem This file is generated from zlib-mingw11.pbat, all edits will be lost
set PATH=C:\Program Files\CMake\bin;C:\mingw1120_64\bin;C:\Program Files\Git\cmd;%PATH%
pushd %~dp0
    if not exist zlib (
        git clone https://github.com/madler/zlib.git
        pushd zlib
            git checkout v1.3.1
        popd
    )
    pushd zlib
        if not exist build mkdir build
        pushd build
            cmake -G "MinGW Makefiles" -D CMAKE_C_COMPILER=gcc -D CMAKE_CXX_COMPILER=g++ -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=C:/zlib-1.3.1 ..
            cmake --build .
            cmake --install .
        popd
    popd
popd