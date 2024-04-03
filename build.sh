#!/bin/bash
set -o errexit -o nounset -o pipefail

# Delete the previous build result.
rm -rf ./build
rm -rf ./prebuild
rm -rf ./libjpeg-turbo

# Set up ndk path.
export NDK=/path/to/ndk

# Only choose one of these:
# for linux
#export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
# for windows
#export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/windows-x86_64
# for mac
export TOOLCHAIN=$NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64

# Check out libpng.
# Set this to libpng version. 
git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git -b 3.0.2

# Set this to your minSdkVersion.
export ANDROID_API=21

mkdir build
cd build

abis=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")
d_arms=("-DANDROID_ARM_MODE=arm" "-DANDROID_ARM_MODE=arm" "" "")
d_asm_flags=("-DCMAKE_ASM_FLAGS=--target=aarch64-linux-android${ANDROID_API}" \
         "-DCMAKE_ASM_FLAGS=--target=armv7a-linux-androideabi${ANDROID_API}" \
        "" \
        "") 

abis_length=${#abis[@]}
for (( i=0; i<abis_length; i++ )); do
    rm -rf ./*
    abi=${abis[i]}
    d_arm=${d_arms[i]}
    d_asm_flag=${d_asm_flags[i]} 
    echo "Building for {$abi}..."
    cmake -G"Unix Makefiles" \
        -DANDROID_ABI=$abi \
        ${d_arm} \
        -DANDROID_PLATFORM=android-${ANDROID_API} \
        -DANDROID_TOOLCHAIN=${TOOLCHAIN} \
        ${d_asm_flag} \
        -DCMAKE_TOOLCHAIN_FILE=${NDK_PATH}/build/cmake/android.toolchain.cmake \
        ../libjpeg-turbo
    make

    mkdir -p ../prebuild/jpeg/$abi
    mkdir -p ../prebuild/turbojpeg/$abi
    mv libjpeg.a ../prebuild/jpeg/$abi
    mv libturbojpeg.a ../prebuild/turbojpeg/$abi
done

mkdir -p ../include/jpeg/
mkdir -p ../include/turbojpeg/

cp -r jconfig.h ../include/jpeg/
cp -r jversion.h ../include/jpeg/
cp -r ../libjpeg-turbo/jerror.h ../include/jpeg/
cp -r ../libjpeg-turbo/jmorecfg.h ../include/jpeg/
cp -r ../libjpeg-turbo/jpeglib.h ../include/jpeg/

cp -r ../libjpeg-turbo/turbojpeg.h ../include/turbojpeg/
