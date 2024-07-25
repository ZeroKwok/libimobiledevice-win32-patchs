# libimobiledevice-win32-patchs

这是一个基于 [libimobiledevice](https://github.com/libimobiledevice) 官方仓库的 win32 补丁集合，允许官方原版代码可以在 CMake & MSVC 环境下通过编译。

**注意：**

本仓库仅做 MSVC 环境兼容的相关操作, 确保应用补丁后可以正确通过编译以及正常的运行主要功能，而不会修改官方代码所带来的问题。

第一版补丁自 vcpkg 的相关 ports 修改而来。

## 补丁支持状态

```md
# idevicerestore
  - f7e24ce(2024-07-09 11:45:10)
  - ipsw: Fix concurrent access to ZIP file
# libimobiledevice
  - 2a0a6d5(2024-07-01 18:27:27)
  - tools: Fix heap buffer overflow in ideviceimagemounter
# libimobiledevice-glue
  - 362f784(2024-06-16 08:14:12)
  - Update soversion for release
# libirecovery
  - 7ce02c3(2024-05-31 19:11:25)
  - Add iPad Air (M2) and iPad Pro (M4) models
# libplist
  - e8791e2(2024-05-19 13:39:25)
  - [github-actions] codeql-analysis: Update actions to newer version
# libtatsu
  - e3eb2e2(2024-06-17 19:56:30)
  - Updated NEWS for release
# libusbmuxd
  - a7f0543(2024-04-16 16:42:26)
  - automake: Prevent `dist` or `distcheck` when uncommitted changes are present
```

## 构建需要

- 安装最新的 vcpkg，并安装以下依赖库
  - curl
  - zlib
  - libusb
  - libplist
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
