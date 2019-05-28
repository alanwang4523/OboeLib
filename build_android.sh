#!/bin/sh

# Description: This is a generic script that 
# can build statically linked or dynamically linked libraries 
# for Android with C/C++ codes and CMakeList.txt

# Author: AlanWang
# Email: alanwang4523@gmail.com
# Date: 2018-05-15

# You should set the MY_NDK、MY_SDK、MY_CMAKE as your own path
MY_NDK="/Users/AlanWang/AndroidDev/sdk/ndk-bundle"
MY_SDK="/Users/AlanWang/AndroidDev/sdk"
MY_CMAKE="${MY_SDK}/cmake/3.6.3155560/bin/cmake"

OUTPUT_LIBS="./build/libs"
TEMP_OBJ_PATH="./build/obj"

# arme_abis=(armeabi armeabi-v7a arm64-v8a x86 x86_64 mips mips64)
arme_abis=(armeabi-v7a arm64-v8a x86 x86_64)
PLATFORM="android-16"

function build_with_armeabi() {
	ARME_ABI=$1
	echo ${ARME_ABI}

	BUILD_DIR="${TEMP_OBJ_PATH}/${ARME_ABI}"
	PRE_EXE_DIR=$(pwd)
	echo ${PRE_EXE_DIR}

	# use android toolchain to create makefile
	${MY_CMAKE} \
	-H"./" \
	-B"${BUILD_DIR}" \
	-DANDROID_ABI="${ARME_ABI}" \
	-DANDROID_NDK="${MY_NDK}" \
	-DCMAKE_LIBRARY_OUTPUT_DIRECTORY="${BUILD_DIR}" \
	-DCMAKE_BUILD_TYPE="Release" \
	-DCMAKE_TOOLCHAIN_FILE="${MY_NDK}/build/cmake/android.toolchain.cmake" \
	-DANDROID_PLATFORM=${PLATFORM} \
	-DANDROID_TOOLCHAIN="clang" \
	# -DCMAKE_C_FLAGS="-fpic -fexceptions -frtti" \
	# -DCMAKE_CXX_FLAGS="-fpic -fexceptions -frtti" \
	# -DANDROID_STL="c++_static" \

	# enter build dir to execute make and output targets libraries
	cd ${BUILD_DIR}
	make

	# move the output libraries to target path that setted by OUTPUT_LIBS
	cd ${PRE_EXE_DIR}
	mkdir -p ${OUTPUT_LIBS}/${ARME_ABI}/
	mv ${BUILD_DIR}/libs/* ${OUTPUT_LIBS}/${ARME_ABI}/
	rm -r ${TEMP_OBJ_PATH} # delet temp files
}

for i in ${arme_abis[@]}; do
	build_with_armeabi $i
done

