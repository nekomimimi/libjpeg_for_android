# libjpeg_for_android

This bash script builds libjepg static library with NDK for Android.
This script makes "libjpeg.a", "libturbojpeg.a", and include files which are compatible with Android architectures, including arm64-v8a, armeabi-v7a, x86, and x86_64.

This script is based on the following repository:
[ibjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo)

## How to use.

### Download this script
git clone https://github.com/nekomimimi/libpng_for_android.git

### Set the following to the build.sh
#### 1.Set the following to the version of libturbojpeg for compile.
```bash.sh
git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git -b 3.0.2
```

### 2. Set the following to NDK toolchains path.

For example:

```bash.sh
export NDK=/Users/your_id/Library/Android/sdk/ndk/26.2.11394342
```

### 3.Only select the one toolchain about your PC.
#### For Linux:
```bash.sh
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
```

#### For Windows:
```bash.sh
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/windows-x86_64
```

#### For MacOS:
```bash.sh
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
```

### 4.Set the following to your minSdkVersion.
```bash.sh
export API=21
```

### Build
./build.sh

## Warning
This repository is not well-tested, so please thoroughly test it before using.

