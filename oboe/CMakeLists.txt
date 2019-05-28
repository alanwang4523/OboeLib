cmake_minimum_required(VERSION 3.4.1)

set(OBOE_SOURCES_PATH ${CMAKE_CURRENT_SOURCE_DIR})
message(${OBOE_SOURCES_PATH})

file(GLOB CPP_FILES_IN_AUDIO  ${OBOE_SOURCES_PATH}/src/aaudio/*.cpp)
file(GLOB CPP_FILES_IN_COMMON  ${OBOE_SOURCES_PATH}/src/common/*.cpp)
file(GLOB CPP_FILES_IN_FIFO  ${OBOE_SOURCES_PATH}/src/fifo/*.cpp)
file(GLOB CPP_FILES_IN_OPENSLES  ${OBOE_SOURCES_PATH}/src/opensles/*.cpp)

set (oboe_sources
        ${CPP_FILES_IN_AUDIO}
        ${CPP_FILES_IN_COMMON}
        ${CPP_FILES_IN_FIFO}
        ${CPP_FILES_IN_OPENSLES}
        )


# if you don't want to build statically linked libraries，you can set BUILD_OBOE_STATIC OFF

option(BUILD_OBOE_STATIC "build oboe statically linked libraries?" ON)
if(BUILD_OBOE_STATIC)
    add_library(oboe_st STATIC ${oboe_sources})
    SET_TARGET_PROPERTIES(oboe_st PROPERTIES OUTPUT_NAME "oboe")

    # Specify directories which the compiler should look for headers
    target_include_directories(oboe_st
                               PRIVATE src
                               PUBLIC include)

    # Compile Flags:
    #     Enable -Werror when building debug config
    #     Enable -Ofast
    target_compile_options(oboe_st
        PRIVATE
        -std=c++11
        -Wall
        -Wextra-semi
        -Wshadow
        -Wshadow-field
        -Ofast
        "$<$<CONFIG:DEBUG>:-Werror>")

    # Enable logging for debug builds
    target_compile_definitions(oboe_st PUBLIC "$<$<CONFIG:DEBUG>:OBOE_ENABLE_LOGGING=1>")

    target_link_libraries(oboe_st PRIVATE log OpenSLES)
endif()


# if you want to build dynamically linked libraries，you can set BUILD_OBOE_SO ON

option(BUILD_OBOE_SO "build oboe dynamically linked libraries?" OFF)
if(BUILD_OBOE_SO)    
    add_library(oboe_so SHARED ${oboe_sources})
    SET_TARGET_PROPERTIES(oboe_so PROPERTIES OUTPUT_NAME "oboe")  

    target_include_directories(oboe_so
                               PRIVATE src
                               PUBLIC include)    

    target_link_libraries(oboe_so PRIVATE log OpenSLES)
endif()
