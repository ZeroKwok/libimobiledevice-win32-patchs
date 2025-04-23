cmake_minimum_required(VERSION 3.15)
project(libirecovery C)

option(LIBIRECOVERY_BUILD_TOOLS "Build tools." ON)
option(LIBIRECOVERY_BUILD_SHARED_LIBS "Build Shared library." ON)

include(GNUInstallDirs)

file(GLOB_RECURSE LIBIRECOVERY_HEADER include/*.h)
file(GLOB_RECURSE LIBIRECOVERY_SOURCE src/*.c)

set(DEFINITIONS)
list(APPEND DEFINITIONS -DPACKAGE_VERSION="1.2")

if(LIBIRECOVERY_BUILD_SHARED_LIBS)
    if(WIN32)
        list(APPEND DEFINITIONS -DIRECV_EXPORT)
    endif()
endif()

if(APPLE)
    list(APPEND DEFINITIONS -DHAVE_IOKIT)
endif()

if(WIN32)
    list(APPEND DEFINITIONS -D_CRT_SECURE_NO_WARNINGS)
    list(APPEND DEFINITIONS -DWIN32_LEAN_AND_MEAN)
    list(APPEND DEFINITIONS -DWIN32)
endif()

if (NOT TARGET libimobiledevice-glue)
    find_package(unofficial-libimobiledevice-glue CONFIG REQUIRED)
endif()

add_library(libirecovery SHARED ${LIBIRECOVERY_SOURCE})
add_library(unofficial::libirecovery::libirecovery ALIAS libirecovery)
target_include_directories(libirecovery PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/patchs>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_compile_options(libirecovery PRIVATE /FImsvc.h)
target_compile_definitions(libirecovery PRIVATE ${DEFINITIONS})
target_link_libraries(libirecovery
    PRIVATE
        unofficial::libimobiledevice-glue::libimobiledevice-glue
)
if(NOT WIN32 AND NOT APPLE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(libusb REQUIRED IMPORTED_TARGET libusb-1.0)
    target_link_libraries(libirecovery PRIVATE PkgConfig::libusb)
endif()
set_target_properties(libirecovery PROPERTIES OUTPUT_NAME irecovery-1.0)

if(WIN32)
    target_link_libraries(libirecovery PRIVATE Setupapi)
endif()

if(APPLE)
    target_link_libraries(libirecovery PRIVATE "-framework IOKit" "-framework CoreFoundation")
endif()

if(NOT LIBIRECOVERY_BUILD_SHARED_LIBS)
    target_compile_definitions(libirecovery PUBLIC -DIRECV_STATIC)

    include(cmake_utility)
    utility_install_pdb(libirecovery)
else()
    set_target_properties(libirecovery PROPERTIES DEBUG_POSTFIX "d")
endif()

install(TARGETS libirecovery EXPORT unofficial-libirecovery)

install(
    EXPORT unofficial-libirecovery
    FILE unofficial-libirecovery-config.cmake
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-libirecovery"
    NAMESPACE unofficial::libirecovery::
)

install(
    FILES ${LIBIRECOVERY_HEADER}
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

set(LIMD_GLUE_VERSION 1.2)
set(PACKAGE_NAME libirecovery)
set(PACKAGE_VERSION 1.2)
set(prefix "")
set(exec_prefix "\${prefix}")
set(libdir "\${prefix}/lib")
set(includedir "\${prefix}/include")

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/src/libirecovery-1.0.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/libirecovery-1.0.pc"
    @ONLY
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/libirecovery-1.0.pc"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
)

if(LIBIRECOVERY_BUILD_TOOLS)
    add_executable(irecovery "tools/irecovery.c")
    target_compile_definitions(irecovery PRIVATE
        -DPACKAGE_VERSION="1.1.0"
        -DPACKAGE_URL="https://github.com/libimobiledevice/libirecovery"
        -DPACKAGE_BUGREPORT="https://github.com/libimobiledevice/libirecovery/issues"
    )
    if(NOT LIBIRECOVERY_BUILD_SHARED_LIBS)
        target_compile_definitions(irecovery PRIVATE -DIRECV_STATIC)
    endif()
    if(WIN32)
        target_compile_definitions(irecovery PRIVATE
            -D_CRT_SECURE_NO_WARNINGS
            -DWIN32_LEAN_AND_MEAN
            -DWIN32
        )
        find_package(unofficial-getopt-win32 REQUIRED)
        target_link_libraries(irecovery PRIVATE unofficial::getopt-win32::getopt Ws2_32)
    endif()
    if(APPLE)
        target_compile_definitions(irecovery PRIVATE -DHAVE_IOKIT)
        target_link_libraries(irecovery PRIVATE "-framework IOKit" "-framework CoreFoundation")
    endif()
    if(NOT WIN32 AND NOT APPLE)
        find_package(PkgConfig REQUIRED)
        pkg_check_modules(libusb REQUIRED IMPORTED_TARGET libusb-1.0)
        target_link_libraries(irecovery PRIVATE PkgConfig::libusb)
    endif()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(readline REQUIRED IMPORTED_TARGET readline)
    target_link_libraries(irecovery PRIVATE libirecovery PkgConfig::readline)
    install(
        TARGETS irecovery
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    )
endif()
