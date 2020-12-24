#!/bin/bash

ARCH=$1

source ../Env.sh $ARCH

LIBS_DIR=$(cd `dirname $0`; pwd)/android

cd libvpx

PREFIX=$LIBS_DIR/$AOSP_ABI
echo "PREFIX="$PREFIX

export CC="$CC"
export CXX="$CXX"
export CFLAGS="$FF_CFLAGS -I${ANDROID_NDK_ROOT}/sources/android/cpufeatures"
export CXXFLAGS="$FF_EXTRA_CFLAGS"
export LDFLAGS="-lc -lm"
export AR="${CROSS_PREFIX}ar"
export LD="${CROSS_PREFIX}ld"
export AS="${CROSS_PREFIX}as"
export NM="${CROSS_PREFIX}nm"
export STRIP="${CROSS_PREFIX}strip"

echo "@@@@@@@@@ $STRIP $CC"

TARGET_CPU=""
DISABLE_NEON_FLAG=""
case ${ARCH} in
    arm-v7a)
        TARGET_CPU="armv7"

        # NEON disabled explicitly because
        # --enable-runtime-cpu-detect enables NEON for armv7 cpu
        DISABLE_NEON_FLAG="--disable-neon"
        unset ASFLAGS
    ;;
    arm-v7a-neon)
        # NEON IS ENABLED BY --enable-runtime-cpu-detect
        TARGET_CPU="armv7"
        unset ASFLAGS
    ;;
    arm64-v8a)
        # NEON IS ENABLED BY --enable-runtime-cpu-detect
        TARGET_CPU="arm64"
        unset ASFLAGS
    ;;
    *)
        # INTEL CPU EXTENSIONS ENABLED BY --enable-runtime-cpu-detect
        TARGET_CPU=""
        export ASFLAGS="-D__ANDROID__"
    ;;
esac

make distclean 2>/dev/null 1>/dev/null

CROSS=$CROSS_PREFIX ./configure \
    --prefix=$PREFIX \
    --target="${TARGET_CPU}-android-gcc" \
    --extra-cflags="${CFLAGS}" \
    --extra-cxxflags="${CXXFLAGS}" \
    --as=yasm \
    --log=yes \
    --enable-libs \
    --enable-install-libs \
    --enable-pic \
    --enable-optimizations \
    --enable-better-hw-compatibility \
    ${DISABLE_NEON_FLAG} \
    --enable-vp8 \
    --enable-vp9 \
    --enable-multithread \
    --enable-spatial-resampling \
    --enable-small \
    --enable-static \
    --disable-realtime-only \
    --disable-debug \
    --disable-gprof \
    --disable-gcov \
    --disable-ccache \
    --disable-install-bins \
    --disable-install-srcs \
    --disable-install-docs \
    --disable-docs \
    --disable-tools \
    --disable-examples \
    --disable-unit-tests \
    --disable-decode-perf-tests \
    --disable-encode-perf-tests \
    --disable-codec-srcs \
    --disable-debug-libs \
    --disable-internal-stats || exit 1

make -j16
make install

cd ..
