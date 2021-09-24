# Find s2 geometry cmake module.
#

if(NOT s2_FOUND)

  find_path(s2_INCLUDE_DIR s2/s2point.h
      PATHS "${CMAKE_INSTALL_PREFIX}/include"
      PATHS "${S2_DIR}" ENV S2_DIR
      PATH_SUFFIXES "include"
      )

  find_library(s2_LIBRARY
      NAME s2
      PATHS "${CMAKE_INSTALL_PREFIX}/lib"
      PATHS "${S2_DIR}" ENV S2_DIR
      PATH_SUFFIXES "lib"
      )

  # EXISTS doesn't work on the system include path on linux. :(
  if(s2_INCLUDE_DIR AND s2_LIBRARY)
    set(s2_FOUND TRUE)
  else()
    set(s2_FOUND FALSE)
  endif()

  ### Handle REQUIRED / QUIET optional arguments.
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(s2 DEFAULT_MSG
      s2_INCLUDE_DIR  s2_LIBRARY
      )

  # Set standard CMake FindPackage variables if found.
  if(s2_FOUND)
    set(s2_INCLUDE_DIRS "${s2_INCLUDE_DIR}")
    set(s2_LIBRARIES    "${s2_LIBRARY}")
  endif()

  ### Create target.
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.0 AND s2_FOUND)
    message(STATUS "Creating exported s2::s2 target: '${s2_LIBRARY}'")
    add_library(s2::s2 SHARED IMPORTED)
    set_target_properties(s2::s2 PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES  ${s2_INCLUDE_DIRS}
        IMPORTED_LOCATION              ${s2_LIBRARIES}
        IMPORTED_IMPLIB                ${s2_LIBRARIES}
        )
    set(s2_INCLUDE_DIRS "")
    set(s2_LIBRARIES s2::s2)

    # Only mark internal variables as advanced if we found package, otherwise
    # leave them visible in the standard GUI for the user to set manually.
    mark_as_advanced(FORCE s2_INCLUDE_DIR s2_LIBRARY)
  endif()

endif(NOT s2_FOUND)
