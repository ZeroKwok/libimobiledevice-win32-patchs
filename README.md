# libimobiledevice-win32-patchs

这是一个基于 [libimobiledevice](https://github.com/libimobiledevice) 官方仓库的 win32 补丁集合，允许官方原版代码可以在 CMake & MSVC 环境下通过编译。

**注意：**

本仓库仅做 MSVC 环境兼容的相关操作, 确保应用补丁后可以正确通过编译以及正常的运行主要功能，而不会修改来自上游的问题。

第一版补丁自 vcpkg 的相关 ports 修改而来。

## 补丁支持状态

Update to 2025-09-25

```md
# idevicerestore
  - eda43ac(2025-09-23 00:07:28)
  - Fix progress bar for DFU/Recovery image upload
# libimobiledevice
  - 54f6437(2025-09-08 00:16:19)
  - Add FUNDING
# libimobiledevice-glue
  - 0779631(2025-09-08 00:14:41)
  - Add FUNDING
# libirecovery
  - 23f201d(2025-09-12 11:28:13)
  - Update NEWS for release
# libplist
  - 91ba426(2025-09-12 12:44:39)
  - Fix proper use of calloc
# libtatsu
  - 60a39f3(2025-09-22 22:56:37)
  - tss: Update client version and add Ap,Timestamp
# libusbmuxd
  - 93eb168(2025-09-08 00:15:01)
  - Add FUNDING
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
