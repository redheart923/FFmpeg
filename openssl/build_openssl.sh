#!/bin/bash

ARCH=armv8a

source ../Env.sh $ARCH

export ANDROID_NDK_HOME=$ANDROID_NDK_ROOT
export PATH=$TOOLCHAIN/bin:$PATH

LIBS_DIR=$(cd `dirname $0`; pwd)/android/$AOSP_ABI

./Configure \
	--prefix=$LIBS_DIR \
	$OPENSSL_ARCH \
	-D__ANDROID_API__=$AOSP_API

make -j16
make install -j16
