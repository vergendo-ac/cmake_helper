cmake_minimum_required(VERSION 3.13)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/modules")

include(CheckCXXSourceCompiles)

if (CMAKE_CXX_COMPILER_ID MATCHES "^MSVC$")
  set(IS_MSVC ON)
endif()

# Setup required configuration if needed
#
get_cmake_property(is_multi GENERATOR_IS_MULTI_CONFIG)
message(STATUS "GENERATOR_IS_MULTI_CONFIG = ${is_multi}")

set(DEFAULT_CONFIGURATION "RelWithDebInfo")

if (NOT CMAKE_BUILD_TYPE)
  if (NOT CMAKE_CONFIGURATION_TYPES)
    if (is_multi)
      set(CMAKE_CONFIGURATION_TYPES ${DEFAULT_CONFIGURATION})
    else()
      set(CMAKE_BUILD_TYPE ${DEFAULT_CONFIGURATION})
    endif()
    # Add debug information to the "empty" config, optimization? NDEBUG?
    if (IS_MSVC)
      add_compile_options("/Zi")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG")
    else()
      add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-g3>)
    endif()
    message(STATUS "Build type not specified, using default ${DEFAULT_CONFIGURATION}")
  else()
    list(LENGTH CMAKE_CONFIGURATION_TYPES num_types)
    message(STATUS "Specified ${num_types} configurations: ${CMAKE_CONFIGURATION_TYPES}")
    if (NOT is_multi)
      message(WARNING "Specified CMAKE_CONFIGURATION_TYPES doesn't supported by the active generator")
    endif()
  endif()
else(NOT CMAKE_BUILD_TYPE)
  message(STATUS "Build type specified as ${CMAKE_BUILD_TYPE}")
  if (is_multi)
    message(WARNING "Specified CMAKE_BUILD_TYPE is ignored by multi-config generator")
  endif()
endif(NOT CMAKE_BUILD_TYPE)

# Setup required options
#
if (IS_MSVC)
  # Add additional options for MSVC build tools to unify using cmake stuff with
  # different packages.
  include(MSVC_addons)
else()
  if (ASAN_BUILD)
    add_compile_options("-fsanitize=address")
    link_libraries("-fsanitize=address")
  endif()
endif()

# libstdc++ from pre-9 GCC versions requires an additional library
# for c++17 std::filesystem.
#
check_cxx_source_compiles("
#include <iosfwd>
#if defined(_GLIBCXX_RELEASE)
#if _GLIBCXX_RELEASE < 9
#error libstdc++ version requires stdc++fs linkage
#endif
#endif
int main() { return 0; }
"
NOT_GLIBCXX_NEEDS_FS_LIB)

if (NOT_GLIBCXX_NEEDS_FS_LIB)
  set(FILESYSTEM_LIBRARY "")
else()
  set(FILESYSTEM_LIBRARY "stdc++fs")
endif()
