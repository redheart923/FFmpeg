#!/bin/bash

source Env.sh $ARCH

PREFIX=$(pwd)/android/$CPU

########### x264
X264_LIBS_DIR=$(pwd)/libx264/android/$AOSP_ABI
# pkg-config
# or
# X264_INCLUDE=$X264_LIBS_DIR/include
# X264_LIB=$X264_LIBS_DIR/lib
# --extra-cflags="-I$X264_INCLUDE"
# --extra-ldflags="-L$X264_LIB "
X264_PKG_PATH="$X264_LIBS_DIR/lib/pkgconfig"
export PKG_CONFIG_PATH=$X264_PKG_PATH:$PKG_CONFIG_PATH

########### aac
AAC_LIBS_DIR=$(pwd)/fdk-aac/android/$AOSP_ABI
AAC_PKG_PATH="$AAC_LIBS_DIR/lib/pkgconfig"
export PKG_CONFIG_PATH=$AAC_PKG_PATH:$PKG_CONFIG_PATH

echo $PKG_CONFIG_PATH

function build_android
{
echo "Compiling FFmpeg for $CPU and prefix is $PREFIX"
./configure \
    --prefix=$PREFIX \
    --disable-x86asm \
    --disable-neon \
    --disable-hwaccels \
    --disable-postproc \
    --enable-shared \
    --enable-jni \
    --enable-gpl \
    --enable-libx264 \
    --enable-nonfree \
    --enable-libfdk-aac \
    --disable-mediacodec \
    --disable-decoder=h264_mediacodec \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --pkg-config=$(which pkg-config) \
    --arch=$AOSP_ARCH \
    --cpu=$CPU \
    --cc=$CC \
    --cxx=$CXX \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS " \
    --extra-ldflags="$ADDI_LDFLAGS " \
    $ADDITIONAL_CONFIGURE_FLAG

make clean
make -j16
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

build_android
