# Find tinyxml2 cmake module.
#
# Indeed this module, which taken from https://github.com/leethomason/tinyxml2
# has a full cmake support and could be properly found with its cmake files.
# For those systems, where it comes without cmake support, this file is useful.
#
#
# This module will set the following variables:
#
# tinyxml2_FOUND
# tinyxml2_INCLUDE_DIRS
# tinyxml2_LIBRARIES
#
# This module tries to create the target "tinyxml2::tinyxml2" that may be used
# when building executables and libraries via target_link_libraries(my_module).
# In this case tinyxml2_INCLUDE_DIRS will be empty and tinyxml2_LIBRARIES will
# get the target name to be sure that target is activated properly.
# For old CMake versions tinyxml2_INCLUDE_DIRS and tinyxml2_LIBRARIES will have
# includes and libraries paths.
#

if(NOT tinyxml2_FOUND)

  find_path(tinyxml2_INCLUDE_DIR tinyxml2.h
      PATHS "${CMAKE_INSTALL_PREFIX}/include"
      PATHS "${TINYXML2_DIR}" ENV TINYXML2_DIR
      PATH_SUFFIXES "include"
      )
      
  find_library(tinyxml2_LIBRARY
      NAMES "tinyxml2" "libtinyxml2"
      PATHS "${CMAKE_INSTALL_PREFIX}/lib"
      PATHS "${TINYXML2_DIR}" ENV TINYXML2_DIR
      PATH_SUFFIXES "lib"
      )

  # EXISTS doesn't work on the system include path on linux. :(
  if(tinyxml2_INCLUDE_DIR AND tinyxml2_LIBRARY)
    set(tinyxml2_FOUND TRUE)
  else()
    set(tinyxml2_FOUND FALSE)
  endif()

  ### Handle REQUIRED / QUIET optional arguments.
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(tinyxml2 DEFAULT_MSG
      tinyxml2_INCLUDE_DIR  tinyxml2_LIBRARY
      )

  # Set standard CMake FindPackage variables if found.
  if(tinyxml2_FOUND)
    set(tinyxml2_INCLUDE_DIRS "${tinyxml2_INCLUDE_DIR}")
    set(tinyxml2_LIBRARIES    "${tinyxml2_LIBRARY}")
  endif()

  ### Create target.
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.0 AND tinyxml2_FOUND)
    message(STATUS "Creating exported tinyxml2::tinyxml2 target: '${tinyxml2_LIBRARY}'")
    add_library(tinyxml2::tinyxml2 SHARED IMPORTED)
    set_target_properties(tinyxml2::tinyxml2 PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES  ${tinyxml2_INCLUDE_DIRS}
        IMPORTED_LOCATION              ${tinyxml2_LIBRARIES}
        IMPORTED_IMPLIB                ${tinyxml2_LIBRARIES}
        )
    set(tinyxml2_INCLUDE_DIRS "")
    set(tinyxml2_LIBRARIES tinyxml2::tinyxml2)

    # Only mark internal variables as advanced if we found package, otherwise
    # leave them visible in the standard GUI for the user to set manually.
    mark_as_advanced(FORCE tinyxml2_INCLUDE_DIR tinyxml2_LIBRARY)
  endif()

endif(NOT tinyxml2_FOUND)
