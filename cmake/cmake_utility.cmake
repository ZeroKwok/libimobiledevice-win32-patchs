# This file is part of the utility project.
# Copyright (c) 2020-2024 zero <zero.kwok@foxmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

cmake_minimum_required(VERSION 3.13)

# 为静态库目标安装 PDB 文件
function(utility_install_pdb target_name)
    if (NOT MSVC)
        return()
    endif()

    get_target_property(PROJECT_OUTPUT_NAME ${target_name} OUTPUT_NAME)
    if (NOT PROJECT_OUTPUT_NAME)
        set(PROJECT_OUTPUT_NAME ${target_name})
    endif()

    set_target_properties(${target_name} PROPERTIES DEBUG_POSTFIX "d")
    set_target_properties(${target_name} PROPERTIES 
        PDB_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
        COMPILE_PDB_NAME_DEBUG  "${PROJECT_OUTPUT_NAME}d"
        COMPILE_PDB_NAME_RELEASE ${PROJECT_OUTPUT_NAME}
        COMPILE_PDB_NAME_MINSIZEREL ${PROJECT_OUTPUT_NAME}
        COMPILE_PDB_NAME_RELWITHDEBINFO ${PROJECT_OUTPUT_NAME})

    get_target_property(PROJECT_PDB_NAME_DEBUG    ${target_name} COMPILE_PDB_NAME_DEBUG)
    get_target_property(PROJECT_PDB_NAME_RELEASE  ${target_name} COMPILE_PDB_NAME_RELEASE)
    get_target_property(PROJECT_PDB_DIRECTORY     ${target_name} PDB_OUTPUT_DIRECTORY)
    set(PROJECT_PDB_NAME "$<$<CONFIG:Debug>:${PROJECT_PDB_NAME_DEBUG}>$<$<NOT:$<CONFIG:Debug>>:${PROJECT_PDB_NAME_RELEASE}>.pdb")
    
    # 在 Shell 中 pdb 输出目录为 ${PROJECT_PDB_DIRECTORY}/${CMAKE_INSTALL_CONFIG_NAME}
    install(FILES "${PROJECT_PDB_DIRECTORY}/\${CMAKE_INSTALL_CONFIG_NAME}/${PROJECT_PDB_NAME}" DESTINATION lib OPTIONAL)
    
    # 在 MSVC(vs2019) 中 pdb 输出目录为 ${PROJECT_PDB_DIRECTORY}/${CMAKE_INSTALL_CONFIG_NAME}
    install(FILES "${PROJECT_PDB_DIRECTORY}/${PROJECT_PDB_NAME}" DESTINATION lib OPTIONAL)
endfunction()

# 修复版本号, 补全4位
# 列如下面的声明将导致 ${PROJECT_VERSION_TWEAK} 的值为空
#
# project(xxx VERSION 0.3.0)
function(utility_fix_project_version)
    if (NOT PROJECT_VERSION_MAJOR)
        set(PROJECT_VERSION_MAJOR 0 PARENT_SCOPE)
    endif()
    if (NOT PROJECT_VERSION_MINOR)
        set(PROJECT_VERSION_MINOR 0 PARENT_SCOPE)
    endif()
    if (NOT PROJECT_VERSION_PATCH)
        set(PROJECT_VERSION_PATCH 0 PARENT_SCOPE)
    endif()
    if (NOT PROJECT_VERSION_TWEAK)
        set(PROJECT_VERSION_TWEAK 0 PARENT_SCOPE)
    endif()
endfunction()

# 打印执行目标的所有属性
# 主要用于辅助调试 CMake 脚本
function(utility_print_target_properties target_name)
    if(NOT TARGET ${target_name})
        message(FATAL_ERROR "There is no target named '${target_name}'")
        return()
    endif()

    if (NOT CMAKE_PROPERTY_LIST)
        # Get all propreties that cmake supports
        execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

        # Convert command output into a CMake list
        STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
        STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
    endif()

    foreach (prop ${CMAKE_PROPERTY_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
        if(prop STREQUAL "LOCATION" OR prop MATCHES "^LOCATION_" OR prop MATCHES "_LOCATION$")
            continue()
        endif()

        # message ("Checking ${prop}")
        get_property(propval TARGET ${target_name} PROPERTY ${prop} SET)
        if (propval)
            get_target_property(propval ${target_name} ${prop})
            message (DEBUG "${target_name} ${prop} = ${propval}")
        endif()
    endforeach(prop)
endfunction()

# 打印当前 CMakeLists.txt 的变量
# 主要用于辅助调试 CMake 脚本
function(utility_print_current_variables)
    get_cmake_property(_variableNames VARIABLES)
    foreach (_variableName ${_variableNames})
        message(DEBUG "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()