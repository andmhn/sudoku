#!/bin/bash

source "$HOME/repos/emsdk/emsdk_env.sh" || exit
mkdir -p build/emc 
# Ensure asset folder is copied
rm -rf build/emc/assets || true
cp -R assets build/emc/assets
export CPLUS_INCLUDE_PATH=
cd build/emc &&
emcmake cmake ../.. -DPLATFORM=Web -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-s USE_GLFW=3" -DCMAKE_EXECUTABLE_SUFFIX=".html" &&
emmake make

# now update chess_web folder
cd ../..
mkdir -p ../chess_web
rm -rf ../chess_web/*
cp build/emc/chess.* ../chess_web
mv ../chess_web/chess.html ../chess_web/index.html
cp -R assets ../chess_web

