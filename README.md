# libimobiledevice-win32-patchs

这是一个基于 [libimobiledevice](https://github.com/libimobiledevice) 官方仓库的 win32 补丁集合，允许官方原版代码可以在 CMake & MSVC 环境下通过编译。

**注意：**

本仓库仅做 MSVC 环境兼容的相关操作, 确保应用补丁后可以正确通过编译以及正常的运行主要功能，而不会修改官方代码所带来的问题。

第一版补丁自 vcpkg 的相关 ports 修改而来。

## 补丁支持状态

Update to 2025-04-23

```md
# idevicerestore
  - a5905b7(2025-03-27 01:52:20)
  - Fix iPhone 16e restore from normal mode
# libimobiledevice
  - a6b6c35(2025-02-28 13:22:09)
  - tool/afcclient: Fix local file name error on pulling folder from device
# libimobiledevice-glue
  - c915351(2025-03-01 14:48:09)
  - socket: Use a backwards-compatible way to deal with , before __VA_ARGS__
# libirecovery
  - 638056a(2025-03-20 16:01:33)
  - Add support for all March 2025 Apple devices
# libplist
  - d031e94(2025-04-06 12:38:45)
  - C++: Data: Add const char* constructor
# libtatsu
  - 7e1647b(2024-12-27 01:52:31)
  - Add extern "C" guards to public headers
# libusbmuxd
  - 19d6bec(2025-02-16 23:48:32)
  - inetcat: Make sure to report correct error messages
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
