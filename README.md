# libimobiledevice-win32-patchs

这是一个基于 [libimobiledevice](https://github.com/libimobiledevice) 官方仓库的 win32 补丁集合，允许官方原版代码可以在 CMake & MSVC 环境下通过编译。

**注意：**

本仓库仅做 MSVC 环境兼容的相关操作, 确保应用补丁后可以正确通过编译以及正常的运行主要功能，而不会修改官方代码所带来的问题。

第一版补丁自 vcpkg 的相关 ports 修改而来。

## 补丁支持状态

Update to 2024-11-05

```md
# idevicerestore
  - 61a76ce(2024-11-03 22:09:54)
  - [github-actions] Update curl workflow to build 8.10.1 for UCRT64
# libimobiledevice
  - 5aebbc0(2024-10-27 16:07:30)
  - configure: Fine-tuning for MinGW/msys build
# libimobiledevice-glue
  - 5140e4f(2024-10-29 11:12:26)
  - socket.c: define AI_NUMERICSERV if undefined
# libirecovery
  - 7a5e619(2024-11-05 02:55:37)
  - Fix conditional compile for libreadline
# libplist
  - a5df0a6(2024-10-22 19:35:40)
  - Update README
# libtatsu
  - 1d31ade(2024-10-28 00:21:16)
  - configure: Fine-tuning for MinGW/msys build
# libusbmuxd
  - dd0d0d4(2024-10-22 19:36:50)
  - Updated README
```

## 构建需要

- 安装最新的 vcpkg，并安装以下依赖库
  - curl
  - zlib
  - libusb
  - readline
  - openssl
  - getopt
  - dirent
  - pkgconf
- git bash
- rsync
- CMake 3.15 and later
- Visual Studio 2019 and later

## 构建

```bash
git clone --recursive https://github.com/ZeroKwok/libimobiledevice-win32-patchs.git
cd libimobiledevice-win32-patchs
./patch.sh # entry y
mkdir build && cd build
cmake -G "Visual Studio 16 2019" -A Win32 .. -DCMAKE_TOOLCHAIN_FILE="G:/local/vcpkg/scripts/buildsystems/vcpkg.cmake" -DCMAKE_INSTALL_PREFIX="../installed"
cmake --build .
cmake --install .
```
