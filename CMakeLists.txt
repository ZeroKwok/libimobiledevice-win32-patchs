cmake_minimum_required(VERSION 3.13)

project(libimobiledevice)

if(MSVC)
    add_compile_options(/utf-8)
endif()

if (${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    message("CMAKE_CURRENT_SOURCE_DIR==CMAKE_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG          ${CMAKE_CURRENT_SOURCE_DIR}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE        ${CMAKE_CURRENT_SOURCE_DIR}/bin)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_CURRENT_SOURCE_DIR}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG          ${CMAKE_CURRENT_SOURCE_DIR}/bin/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE        ${CMAKE_CURRENT_SOURCE_DIR}/bin/lib)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_CURRENT_SOURCE_DIR}/bin/lib)
endif()

add_subdirectory(libplist)
add_subdirectory(libimobiledevice-glue)
add_subdirectory(libusbmuxd)
add_subdirectory(libimobiledevice)
add_subdirectory(libirecovery)
add_subdirectory(idevicerestore)