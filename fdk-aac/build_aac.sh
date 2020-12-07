#!/bin/bash

ARCH=$1

source ../Env.sh $ARCH

LIBS_DIR=$(cd `dirname $0`; pwd)/android

cd fdk-aac-2.0.1


PREFIX=$LIBS_DIR/$AOSP_ABI
echo "PREFIX="$PREFIX

export CC="$CC"
export CXX="$CXX"
export CFLAGS="$FF_CFLAGS"
export CXXFLAGS="$FF_EXTRA_CFLAGS"
export LDFLAGS="-lm"
export AR="${CROSS_PREFIX}ar"
export LD="${CROSS_PREFIX}ld"
export AS="${CROSS_PREFIX}as"


./configure \
--prefix=$PREFIX \
--target=android \
--with-sysroot=$SYSROOT \
--enable-static \
--disable-shared \
--host=$HOST 


make clean
make -j16
make install

cd ..
