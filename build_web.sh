#!/bin/bash

BIN=$1

if [ -z "$1" ]
  then
    BIN=sudoku
fi

source "$HOME/repos/emsdk/emsdk_env.sh" || exit
mkdir -p build/emc 
# Ensure asset folder is copied
rm -rf build/emc/assets || true
cp -R assets build/emc/assets
export CPLUS_INCLUDE_PATH=
cd build/emc &&
emcmake cmake ../.. -DPLATFORM=Web -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-s USE_GLFW=3" -DCMAKE_EXECUTABLE_SUFFIX=".html" &&
emmake make

# now update ${BIN}_web folder
echo "Copying the build files to : $(realpath ../../../${BIN}_web)"
cd ../..
mkdir -p ../${BIN}_web
rm -rf ../${BIN}_web/*
cp build/emc/${BIN}.* ../${BIN}_web
mv ../${BIN}_web/${BIN}.html ../${BIN}_web/index.html
cp -R assets ../${BIN}_web

