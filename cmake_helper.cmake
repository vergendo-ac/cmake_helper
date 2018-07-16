cmake_minimum_required(VERSION 3.11)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/modules")

if (CMAKE_CXX_COMPILER_ID MATCHES "^MSVC$")
    include(MSVC_addons)
endif()
