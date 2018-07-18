cmake_minimum_required(VERSION 3.11)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/modules")

if (CMAKE_CXX_COMPILER_ID MATCHES "^MSVC$")
  # Add additional options for MSVC build tool to unify using cmake stuff with different packages
  include(MSVC_addons)
endif()

if (NOT CMAKE_CXX_COMPILER_ID MATCHES "^MSVC$")
  if (ASAN_BUILD)
    add_compile_options("-fsanitize=address")
    link_libraries("-fsanitize=address")
  endif()
endif()

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE RelWithDebInfo)
  if (CMAKE_CXX_COMPILER_ID MATCHES "^MSVC$")
    add_compile_options("/Zi")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG")
  else()
    add_compile_options("-g3")
  endif()
endif()
