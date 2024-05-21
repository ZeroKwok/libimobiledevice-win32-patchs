# libimobiledevice-win32-patchs

这是一个基于 libimobiledevice 官方仓库的 win32 补丁集合，允许官方原版代码可以在 CMake & MSVC 环境下通过编译。

**注意：**

本仓库仅做 MSVC 环境兼容的相关操作, 确保运用补丁后可以正确通过编译以及正常的运行主要功能，而不会修改官方代码所带来的问题。

## 补丁支持状态

```txt
# idevicerestore
  - 56d2c01(2024-05-18 23:50:02)
  - Add missing cast to silence compiler warning
# libimobiledevice
  - 9ccc522(2024-05-20 17:48:13)
  - tools/afcclient: Add missing argument count check for `get` command
# libimobiledevice-glue
  - 14c2e4b(2024-05-13 19:49:40)
  - socket: Create an IPv4 compatible IPv6 socket when NULL is passed to socket_create
# libirecovery
  - 617fb57(2024-04-16 16:43:14)
  - automake: Prevent `dist` or `distcheck` when uncommitted changes are present
# libplist
  - e8791e2(2024-05-19 13:39:25)
  - [github-actions] codeql-analysis: Update actions to newer version
# libusbmuxd
  - a7f0543(2024-04-16 16:42:26)
  - automake: Prevent `dist` or `distcheck` when uncommitted changes are present
```

## 构建需要

- 安装最新的 vcpkg，并安装以下依赖库
  - libusb
  - libplist
  - openssl
  - pkgconf
- git bash
- rsync
- CMake 3.15 and later
- Visual Studio 2019 and later

## 构建

```bash
git clone --recursive https://github.com/ZeroKwok/libimobiledevice-win32-patchs.git
cd libimobiledevice-win32-patchs
./export.sh # entry y
mkdir build && cd build
cmake -G "Visual Studio 16 2019" -A Win32 .. -DCMAKE_TOOLCHAIN_FILE="G:/local/vcpkg/scripts/buildsystems/vcpkg.cmake" -DCMAKE_INSTALL_PREFIX="../installed"
cmake --build .
cmake --install .
```
