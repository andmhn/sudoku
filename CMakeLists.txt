cmake_minimum_required(VERSION 3.11) # FetchContent is available in 3.11+
project(chess)

# Generate compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Dependencies
set(RAYLIB_VERSION 4.5.0)
include(FetchContent)
FetchContent_Declare(
  raylib
  DOWNLOAD_EXTRACT_TIMESTAMP OFF
  URL https://github.com/raysan5/raylib/archive/refs/tags/${RAYLIB_VERSION}.tar.gz
)
FetchContent_GetProperties(raylib)
if (NOT raylib_POPULATED) # Have we downloaded raylib yet?
  set(FETCHCONTENT_QUIET NO)
  FetchContent_Populate(raylib)
  set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE) # don't build the supplied examples
  add_subdirectory(${raylib_SOURCE_DIR} ${raylib_BINARY_DIR})
endif()

# Our Project

file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_LIST_DIR}/sources/*.c")
set(PROJECT_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/sources/")

# Declaring our executable
add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} PRIVATE ${PROJECT_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE ${PROJECT_INCLUDE})
target_link_libraries(${PROJECT_NAME} PRIVATE raylib)


##########################################################################################
# Project build settings
##########################################################################################

add_definitions( -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} )

if (CMAKE_BUILD_TYPE MATCHES "Test")
    file(GLOB_RECURSE TEST_SOURCES "${CMAKE_CURRENT_LIST_DIR}/tests/*.c")
    target_sources(${PROJECT_NAME} PRIVATE ${TEST_SOURCES})
    SET(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -O0 -DDEBUG -DTEST")
    target_compile_definitions(${PROJECT_NAME} PUBLIC ASSETS_PATH="${CMAKE_CURRENT_SOURCE_DIR}/assets/")

elseif (CMAKE_BUILD_TYPE MATCHES "Debug")
    SET(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -O0 -DDEBUG")
    # Set the asset path macro to the absolute path on the dev machine
    target_compile_definitions(${PROJECT_NAME} PUBLIC ASSETS_PATH="${CMAKE_CURRENT_SOURCE_DIR}/assets/")
else()
    # Set the asset path macro in release mode to a relative path that assumes the assets folder is in the same directory as the game executable
    target_compile_definitions(${PROJECT_NAME} PUBLIC ASSETS_PATH="./assets/")
endif()

# Set common compiler flags
SET(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -Wall")

if (${PLATFORM} STREQUAL "Web")
    # Tell Emscripten to build an .html file.
    set(CMAKE_EXECUTABLE_SUFFIX ".html")
    SET(CMAKE_C_FLAGS  "${CMAKE_C_FLAGS} -Os")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s USE_GLFW=3 -s ASSERTIONS=1 -s WASM=1 -Os -Wall -s TOTAL_MEMORY=67108864 -s FORCE_FILESYSTEM=1 --preload-file assets/ --shell-file ${CMAKE_CURRENT_SOURCE_DIR}/sources/minshell.html")
    set(CMAKE_EXECUTABLE_SUFFIX ".html") # This line is used to set executable to build with the emscripten html
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
endif()

