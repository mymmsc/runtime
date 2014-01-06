#!/bin/sh
export ANDROID_NDK=/home/system/soft/work/android-ndk-r9b                                                                                                   
export TOOLCHAIN=/home/system/soft/work/tmp/ffmpeg
export SYSROOT=$TOOLCHAIN/sysroot/
$ANDROID_NDK/build/tools/make-standalone-toolchain.sh --platform=android-14 --install-dir=$TOOLCHAIN

export PATH=$TOOLCHAIN/bin:$PATH
export CC=arm-linux-androideabi-gcc
export LD=arm-linux-androideabi-ld
export AR=arm-linux-androideabi-ar

CFLAGS="-O3 -Wall -mthumb -pipe -fpic -fasm -finline-limit=300 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -fmodulo-sched -fmodulo-sched-allow-regmoves -Wno-psabi -Wa,--noexecstack -D__ARM_ARCH_5__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5TE__ -DANDROID -DNDEBUG"

EXTRA_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mvectorize-with-neon-quad"
EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"

FFMPEG_FLAGS="--prefix=/home/system/runtime/apps/ffmpeg/build --target-os=linux --arch=arm --enable-cross-compile --cc=arm-linux-androideabi-gcc --cross-prefix=arm-linux-androideabi- --enable-shared --disable-symver --disable-doc --disable-ffplay  --disable-ffmpeg --disable-ffprobe --disable-ffserver --disable-avdevice --disable-avfilter --disable-encoders --disable-muxers --disable-filters  --disable-devices --disable-everything --enable-protocols --enable-parsers --enable-demuxers --disable-demuxer=sbg --enable-decoder=h264 --enable-bsfs --enable-network --enable-swscale --enable-asm --enable-version3"
./configure $FFMPEG_FLAGS --extra-cflags="$CFLAGS $EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS"
make clean
make -j4
make install     
