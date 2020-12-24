export ANDROID_NDK_ROOT=/workstation/software/Android/Sdk/ndk/21.3.6528147
export AOSP_API="29"

OS="`uname`"
case $OS in
  'Linux')
    HOST_TAG='linux-x86_64'
    ;;
  'FreeBSD')
    HOST_TAG='FreeBSD'
    ;;
  'WindowsNT')
    HOST_TAG='windows-x86_64'
    ;;
  'Darwin') 
    HOST_TAG='darwin-x86_64'
    ;;
  'SunOS')
    HOST_TAG='Solaris'
    ;;
  'AIX') ;;
  *) ;;
esac

echo "HOST_TAG = ${HOST_TAG}"

if [ "$#" -lt 1 ]; then
	THE_ARCH=armv7
else
	THE_ARCH=$(tr [A-Z] [a-z] <<< "$1")
fi

case "$THE_ARCH" in
  armv7a|armeabi-v7a)
	TOOLNAME_BASE="arm-linux-androideabi"
	COMPILER_BASE="armv7a-linux-androideabi"
	AOSP_ABI="armeabi-v7a"
	AOSP_ARCH="arm"
	CPU="armv7-a"
	OPENSSL_ARCH="android-arm"
	HOST="arm-linux-androideabi"
	FF_EXTRA_CFLAGS="-DANDROID -Wall -fPIC"
	FF_CFLAGS="-DANDROID -Wall -fPIC"
	OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
	;;
  armv8|armv8a|aarch64|arm64|arm64-v8a)
	TOOLNAME_BASE="aarch64-linux-android"
	COMPILER_BASE="aarch64-linux-android"
	AOSP_ABI="arm64-v8a"
	AOSP_ARCH="arm64"
	CPU="armv8-a"
	OPENSSL_ARCH="android-arm64"
	HOST="aarch64-linux-android"
	FF_EXTRA_CFLAGS="-DANDROID -Wall -fPIC"
	FF_CFLAGS="-DANDROID -Wall -fPIC"
	OPTIMIZE_CFLAGS="-march=$CPU"
	;;
  x86)
	TOOLNAME_BASE="i686-linux-android"
	COMPILER_BASE="i686-linux-android"
	AOSP_ABI="x86"
	AOSP_ARCH="x86"
	CPU="x86"
	OPENSSL_ARCH="android-x86"
	HOST="i686-linux-android"
	FF_EXTRA_CFLAGS="-DANDROID -Wall -fPIC"
	FF_CFLAGS="-DANDROID -Wall -fPIC"
	OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
	;;
  x86_64|x64)
	TOOLNAME_BASE="x86_64-linux-android"
	COMPILER_BASE="x86_64-linux-android"
	AOSP_ABI="x86_64"
	AOSP_ARCH="x86_64"
	CPU="x86_64"
	OPENSSL_ARCH="android-x86_64"
	HOST="x86_64-linux-android"
	FF_EXTRA_CFLAGS="-DANDROID -Wall -fPIC"
	FF_CFLAGS="-DANDROID -Wall -fPIC"
	OPTIMIZE_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"
	;;
  *)
	echo "ERROR: Unknown architecture $1"
	[ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
	;;
esac

TOOLCHAIN=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT=$TOOLCHAIN/sysroot

CROSS_PREFIX=$TOOLCHAIN/bin/$TOOLNAME_BASE-

CC=$TOOLCHAIN/bin/$COMPILER_BASE$AOSP_API-clang
CXX=$TOOLCHAIN/bin/$COMPILER_BASE$AOSP_API-clang++

export CC=$CC
export CXX=$CXX
export AR="${CROSS_PREFIX}ar"
export LD="${CROSS_PREFIX}ld"
export AS="${CROSS_PREFIX}as"
export NM="${CROSS_PREFIX}nm"
export STRIP="${CROSS_PREFIX}strip"
export RANLIB="${CROSS_PREFIX}ranlib"

echo "######################CONFIG######################"
echo "TOOLNAME_BASE="$TOOLNAME_BASE
echo "COMPILER_BASE="$COMPILER_BASE
echo "AOSP_ABI="$AOSP_ABI
echo "AOSP_ARCH="$AOSP_ARCH
echo "HOST="$HOST

echo "CC=$CC"
echo "CXX=$CXX"
echo "######################CONFIG######################"
