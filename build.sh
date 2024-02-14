#!/bin/bash
if [ $# -eq 0 ]; then
    >&2 printf "No arguments provided\nBuilding Release...\n"
    cmake -B build -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Release
    cmake --build ./build && cp build/compile_commands.json .
fi

for arg in "$@"
do
    case $arg in
      clean)
        cd build/ && make clean && cd ..
        cd build-emc && make clean
        ;;
      run)
        ./build/chess
        ;;
      test)
        cmake -B build/test -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Test
        cmake --build ./build/test &&\
            printf "Running Test...\n\n" &&\
            ./build/test/chess
        ;;
      release)
        cmake -B build/release -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Release
        cmake --build ./build/release || exit
        cp ./build/release/chess ./build
        ;;
      debug)
        cmake -B build/debug -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Debug
        cmake --build ./build/debug || exit
        cp build/debug/compile_commands.json .
        cp build/debug/chess build/

        # generate ctags with dependency
        echo "Generating tags..."
        cc -M -I build/debug/_deps/raylib-build/raylib/include/ `find sources -name "*.c"` |\
            sed -e 's/[\\ ]/\n/g' | \
            sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | \
            ctags -L - --c++-kinds=+p --fields=+ianS --extras=+q

        ;;
      web)
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
        ;;
      *)
printf "Invalid arg \'$arg\'\n\
Use these build options\n\
-   clean\n\
-   run\n\
-   test\n\
-   release\n\
-   debug\n\
-   web\n"
        ;;
    esac

done
