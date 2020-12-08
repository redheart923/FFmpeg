#!/bin/bash

BASEDIR=$(pwd)

SED_INLINE="sed -i"

# ENABLE COMMON FUNCTIONS
. ${BASEDIR}/../Env.sh

if [[ -z ${ANDROID_NDK_ROOT} ]]; then
    echo -e "(*) ANDROID_NDK_ROOT not defined\n"
    exit 1
fi

if [[ -z ${THE_ARCH} ]]; then
    echo -e "(*) ARCH not defined\n"
    exit 1
fi

if [[ -z ${AOSP_ABI} ]]; then
    echo -e "(*) API not defined\n"
    exit 1
fi

if [[ -z ${BASEDIR} ]]; then
    echo -e "(*) BASEDIR not defined\n"
    exit 1
fi

# PREPARE PATHS & DEFINE ${INSTALL_PKG_CONFIG_DIR}
LIB_NAME="x265"

# PREPARING FLAGS
BUILD_HOST=$HOST
CFLAGS=""
CXXFLAGS="-std=c++11 -fno-exceptions"
LDFLAGS="-lc -lm -ldl -llog -lc++_shared"

X265_LIBS_DIR=$BASEDIR/android/$AOSP_ABI

ARCH_OPTIONS=""
case ${THE_ARCH} in
    armv7a|armeabi-v7a)
        ARCH_OPTIONS="-DENABLE_ASSEMBLY=0 -DCROSS_COMPILE_ARM=1"
    ;;
    armv8|armv8a|aarch64|arm64|arm64-v8a)
        ARCH_OPTIONS="-DENABLE_ASSEMBLY=0 -DCROSS_COMPILE_ARM=1"
    ;;
    x86)
        ARCH_OPTIONS="-DENABLE_ASSEMBLY=0 -DCROSS_COMPILE_ARM=0"
    ;;
    x86-64)
        ARCH_OPTIONS="-DENABLE_ASSEMBLY=0 -DCROSS_COMPILE_ARM=0"
    ;;
esac

if [ -d "cmake_build" ]; then
    rm cmake_build -rf
fi

mkdir cmake_build || exit 1
cd cmake_build || exit 1

# FIX static_assert ERRORS
${SED_INLINE} 's/gnu++98/c++11/g' ${BASEDIR}/src/${LIB_NAME}/source/CMakeLists.txt

cmake -Wno-dev \
    -DCMAKE_VERBOSE_MAKEFILE=0 \
    -DCMAKE_C_FLAGS="${CFLAGS}" \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
    -DCMAKE_SYSROOT=$SYSROOT \
    -DCMAKE_FIND_ROOT_PATH=$SYSROOT \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$X265_LIBS_DIR \
    -DCMAKE_SYSTEM_NAME=Generic \
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_LINKER=$LD \
    -DCMAKE_AR=$AR \
    -DCMAKE_AS=$AS \
    -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
    -DSTATIC_LINK_CRT=1 \
    -DENABLE_PIC=1 \
    -DENABLE_CLI=0 \
    ${ARCH_OPTIONS} \
    -DCMAKE_SYSTEM_PROCESSOR="${THE_ARCH}" \
    -DENABLE_SHARED=0 ../x265/source || exit 1

make -j16 || exit 1

make install || exit 1
