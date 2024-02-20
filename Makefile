.ONESHELL: # Applies to every targets in the file!
.SHELLFLAGS += -e

BIN:=sudoku

all:debug #tags

run:
	./build/${BIN}

tags:
	cc -M -I build/debug/_deps/raylib-build/raylib/include/ `find sources tests -name "*.c"` |\
		sed -e 's/[\\ ]/\n/g' | sed -e '/^$$/d' -e '/.o:$$/d' |\
		ctags -L - --c++-kinds=+p --fields=+ianS --extras=+q

debug:
	cmake -B build/debug -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Debug
	cmake --build ./build/debug || exit
	cp build/debug/compile_commands.json .
	cp ./build/debug/${BIN} ./build

test:
	cmake -B build/test -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Test
	cmake --build ./build/test &&\
		printf "Running Test...\n\n" &&\
		./build/test/${BIN}

release:
	cmake -B build/release -S . -DPLATFORM=Desktop -DCMAKE_BUILD_TYPE=Release
	cmake --build ./build/release || exit
	cp ./build/release/${BIN} ./build

web:
	./build_web.sh ${BIN}

.PHONY: test clean format release debug tags
