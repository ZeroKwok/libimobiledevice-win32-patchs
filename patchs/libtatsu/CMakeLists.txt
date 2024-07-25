cmake_minimum_required(VERSION 3.15)
project(libtatsu C)

include(GNUInstallDirs)

file(GLOB_RECURSE LIBTATSU_SOURCE src/*.c src/*.h)

file(GLOB_RECURSE LIBTATSU_INCLUDE include/libtatsu/*.h)

set(DEFINITIONS)

list(APPEND DEFINITIONS -DPACKAGE_NAME="libtatsu")
list(APPEND DEFINITIONS -DPACKAGE_VERSION="1.0.0")
list(APPEND DEFINITIONS -DPACKAGE_URL="https://github.com/libimobiledevice/libtatsu")
list(APPEND DEFINITIONS -DPACKAGE_BUGREPORT="https://github.com/libimobiledevice/libtatsu/issues")

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

set(LIBTATSU_DEPEND
    CURL::libcurl
    unofficial::libplist::libplist
    libzip::zip
    OpenSSL::SSL
    OpenSSL::Crypto
    ZLIB::ZLIB)

set(LIBTATSU_INCLUDE_DIR
    ${DIRENT_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/patchs)

add_library(libtatsu STATIC ${LIBTATSU_SOURCE})
add_library(unofficial::libtatsu::libtatsu ALIAS libtatsu)
target_include_directories(libtatsu 
    PRIVATE ${LIBTATSU_INCLUDE_DIR}
    PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
    PUBLIC "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
set_target_properties(libtatsu PROPERTIES PUBLIC_HEADER "${LIBTATSU_INCLUDE}")
target_compile_options(libtatsu PRIVATE /FImsvc.h)
target_compile_definitions(libtatsu PRIVATE ${DEFINITIONS})
target_link_libraries(libtatsu PUBLIC ${LIBTATSU_DEPEND})

if (NOT BUILD_SHARED_LIBS)
    target_compile_definitions(libtatsu PUBLIC LIBTATSU_STATIC)

    include(cmake_utility)
    utility_install_pdb(libtatsu)
endif()

install(TARGETS libtatsu libplist++ EXPORT unofficial-libtatsu)

install(
    EXPORT unofficial-libtatsu
    FILE unofficial-libtatsu-config.cmake
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-libtatsu"
    NAMESPACE unofficial::libtatsu::
)

install(
    DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/include/libtatsu"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

set(PACKAGE_NAME libtatsu)
set(PACKAGE_VERSION 1.0)
set(prefix "")
set(exec_prefix "\${prefix}")
set(libdir "\${prefix}/lib")
set(includedir "\${prefix}/include/libtatsu")

foreach(PLIST_PKGCONFIG libtatsu-1.0.pc)
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/src/${PLIST_PKGCONFIG}.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${PLIST_PKGCONFIG}"
        @ONLY
    )
    install(
        FILES "${CMAKE_CURRENT_BINARY_DIR}/${PLIST_PKGCONFIG}"
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
    )
endforeach()
