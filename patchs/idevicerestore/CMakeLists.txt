cmake_minimum_required(VERSION 3.15)
project(idevicerestore C)

include(GNUInstallDirs)

file(GLOB_RECURSE IDEVICERESTORE_SOURCE src/*.c src/*.h)
list(FILTER IDEVICERESTORE_SOURCE EXCLUDE REGEX "sha(1|512)\\.(c|h)$")

file(GLOB_RECURSE IDEVICERESTORE_INCLUDE src/*.h)
list(FILTER IDEVICERESTORE_INCLUDE EXCLUDE REGEX "sha(1|512)\\.h$")

set(DEFINITIONS)

list(APPEND DEFINITIONS -DPACKAGE_NAME="idevicerestore")
list(APPEND DEFINITIONS -DPACKAGE_VERSION="1.0.0")
list(APPEND DEFINITIONS -DPACKAGE_URL="https://github.com/libimobiledevice/idevicerestore")
list(APPEND DEFINITIONS -DPACKAGE_BUGREPORT="https://github.com/libimobiledevice/idevicerestore/issues")

list(APPEND DEFINITIONS -DHAVE_REVERSE_PROXY)

list(APPEND DEFINITIONS -DHAVE_OPENSSL)
list(APPEND DEFINITIONS -DIRECV_STATIC)

if(UNIX)
    list(APPEND DEFINITIONS -DHAVE_REALPATH)
endif()

if(WIN32)
    list(APPEND DEFINITIONS -D_CRT_SECURE_NO_WARNINGS)
    list(APPEND DEFINITIONS -DWIN32)
endif()

find_package(CURL CONFIG REQUIRED)
find_package(libzip CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(ZLIB REQUIRED)
find_path(DIRENT_INCLUDE_DIR dirent.h REQUIRED)

if (NOT TARGET libplist)
    find_package(unofficial-libplist CONFIG REQUIRED)
endif()

if (NOT TARGET libimobiledevice-glue)
    find_package(unofficial-libimobiledevice-glue CONFIG REQUIRED)
endif()
if (NOT TARGET libimobiledevice)
    find_package(unofficial-libimobiledevice CONFIG REQUIRED)
endif()
if (NOT TARGET libusbmuxd)
    find_package(unofficial-libusbmuxd CONFIG REQUIRED)
endif()
if (NOT TARGET libirecovery)
    find_package(unofficial-libirecovery CONFIG REQUIRED)
endif()
if (NOT TARGET libtatsu)
    find_package(unofficial-libtatsu CONFIG REQUIRED)
endif()

list(APPEND DEFINITIONS -DLIMD_GLUE_STATIC)
list(APPEND DEFINITIONS -DLIBIMOBILEDEVICE_STATIC)
list(APPEND DEFINITIONS -DLIBUSBMUXD_STATIC)
list(APPEND DEFINITIONS -DIRECV_STATIC)

set(IDEVICERESTORE_DEPEND
    CURL::libcurl
    unofficial::libplist::libplist
    unofficial::libimobiledevice::libimobiledevice
    unofficial::libimobiledevice-glue::libimobiledevice-glue
    unofficial::libirecovery::libirecovery
    unofficial::libusbmuxd::libusbmuxd
    unofficial::libtatsu::libtatsu
    libzip::zip
    OpenSSL::SSL
    OpenSSL::Crypto
    ZLIB::ZLIB)

set(IDEVICERESTORE_INCLUDE_DIR
    ${DIRENT_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/patchs)

add_executable(idevicerestore ${IDEVICERESTORE_SOURCE})
target_include_directories(idevicerestore PRIVATE  ${IDEVICERESTORE_INCLUDE_DIR})
target_compile_options(idevicerestore PRIVATE /FImsvc.h)
target_compile_definitions(idevicerestore PRIVATE ${DEFINITIONS})
target_link_libraries(idevicerestore PRIVATE ${IDEVICERESTORE_DEPEND})
if(WIN32)
    find_package(unofficial-getopt-win32 REQUIRED)
    target_link_libraries(idevicerestore PRIVATE unofficial::getopt-win32::getopt)
endif()

add_library(libidevicerestore STATIC ${IDEVICERESTORE_SOURCE})
add_library(unofficial::libidevicerestore::libidevicerestore ALIAS libidevicerestore)
target_include_directories(libidevicerestore 
    PRIVATE ${IDEVICERESTORE_INCLUDE_DIR}
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>"
    PUBLIC "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/libidevicerestore>")
set_target_properties(libidevicerestore PROPERTIES PUBLIC_HEADER "${IDEVICERESTORE_INCLUDE}")
target_compile_options(libidevicerestore PRIVATE /FImsvc.h)
target_compile_definitions(libidevicerestore PRIVATE ${DEFINITIONS})
target_link_libraries(libidevicerestore PUBLIC ${IDEVICERESTORE_DEPEND})


install(TARGETS idevicerestore
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")

include(cmake_utility)
utility_install_pdb(libidevicerestore)

install(TARGETS libidevicerestore EXPORT unofficial-libidevicerestore
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/libidevicerestore"
)
install(
    EXPORT unofficial-libidevicerestore
    FILE unofficial-libidevicerestore-config.cmake
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-libidevicerestore"
    NAMESPACE unofficial::libidevicerestore::
)
install(
    FILES "${CMAKE_CURRENT_LIST_DIR}/src/endianness.h"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)