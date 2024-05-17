# libimobiledevice-win32-patchs

这是一个基于 libimobiledevice 官方仓库的 win32 补丁，使之可以通过 CMake 与 MSVC 系列编译器编译 windows 的版本。

## 需要

- vcpkg
  - libusb
  - libplist
  - openssl
  - pkgconf
- rsync
- git bash

## 构建

```bash
git clone --recursive https://git.7-0.cc/mbackupper/libimobiledevice-win32-patchs.git
cd libimobiledevice-win32-patchs
./export.sh # entry y
mkdir build && cd build

cmake -G "Visual Studio 16 2019" -A Win32 .. -DCMAKE_TOOLCHAIN_FILE="G:/local/vcpkg/scripts/buildsystems/vcpkg.cmake" -DPKG_CONFIG_EXECUTABLE="G:/local/vcpkg/downloads/tools/msys2/d33df895d441a36d/mingw64/bin/pkg-config.exe"
# or
cmake -G "Visual Studio 16 2019" -A Win32 .. -DCMAKE_TOOLCHAIN_FILE="G:/local/vcpkg/scripts/buildsystems/vcpkg.cmake" -DCMAKE_INSTALL_PREFIX="../installed" -DCMAKE_PREFIX_PATH="../installed" -DPKG_CONFIG_EXECUTABLE="G:/local/vcpkg/downloads/tools/msys2/d33df895d441a36d/mingw64/bin/pkg-config.exe"
cmake --build .
cmake --install .
```
