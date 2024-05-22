cmake_minimum_required(VERSION 3.15)
project(libimobiledevice-glue C CXX)

include(GNUInstallDirs)

set(DEFINITIONS)

list(APPEND DEFINITIONS -DPACKAGE_VERSION="1.2")
if(BUILD_SHARED_LIBS)
    if(WIN32)
        list(APPEND LIBIMOBILEDEVICEGLUE_SOURCE exports.def)
    endif()
endif()

if(UNIX)
    list(APPEND DEFINITIONS -DHAVE_GETIFADDRS)
endif()

if(WIN32)
    list(APPEND DEFINITIONS -D_CRT_SECURE_NO_WARNINGS)
    list(APPEND DEFINITIONS -DWIN32)
endif()

if (NOT TARGET libplist)
    find_package(unofficial-libplist CONFIG REQUIRED)
endif()

file(GLOB_RECURSE LIBIMOBILEDEVICEGLUE_SOURCE src/*.c)

add_library(libimobiledevice-glue ${LIBIMOBILEDEVICEGLUE_SOURCE})
add_library(unofficial::libimobiledevice-glue::libimobiledevice-glue ALIAS libimobiledevice-glue)
target_include_directories(libimobiledevice-glue
    PRIVATE
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/patchs>"
    PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)
target_compile_options(libimobiledevice-glue PRIVATE /FImsvc.h)
target_compile_definitions(libimobiledevice-glue PRIVATE ${DEFINITIONS})
target_link_libraries(libimobiledevice-glue 
    PUBLIC
        unofficial::libplist::libplist
)
set_target_properties(libimobiledevice-glue PROPERTIES OUTPUT_NAME imobiledevice-glue-1.0)

if(WIN32)
    target_link_libraries(libimobiledevice-glue PRIVATE Ws2_32 Iphlpapi)
endif()

if(NOT BUILD_SHARED_LIBS)
    target_compile_definitions(libimobiledevice-glue PUBLIC -DLIMD_GLUE_STATIC)
endif()

install(TARGETS libimobiledevice-glue EXPORT unofficial-libimobiledevice-glue)

install(
    EXPORT unofficial-libimobiledevice-glue
    FILE unofficial-libimobiledevice-glue-config.cmake
    DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/unofficial-libimobiledevice-glue"
    NAMESPACE unofficial::libimobiledevice-glue::
)

install(
    DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/include/libimobiledevice-glue"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

set(LIBPLIST_VERSION 2.5)
set(PACKAGE_NAME libimobiledevice-glue)
set(PACKAGE_VERSION 1.2)
set(prefix "")
set(exec_prefix "\${prefix}")
set(libdir "\${prefix}/lib")
set(includedir "\${prefix}/include")

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/src/libimobiledevice-glue-1.0.pc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/libimobiledevice-glue-1.0.pc"
    @ONLY
)
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/libimobiledevice-glue-1.0.pc"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/pkgconfig"
)
