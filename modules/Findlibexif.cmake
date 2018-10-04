# Find libexif cmake module for the native EXIF includes and library.
#
# This module will set the following variables:
#
#  libexif_FOUND          - True if libexif library is found.
#  libexif_INCLUDE_DIRS   - Where to find exif-*.h header files.
#  libexif_LIBRARIES      - Libraries to be linked with executable.
#
# This module tries to create the target "libexif::libexif" that may be used
# when building executables and libraries via target_link_libraries(my_module).
# In this case libexif_INCLUDE_DIRS will be empty and libexif_LIBRARIES will
# get the target name to be sure that target is activated properly.
# For old CMake versions libexif_INCLUDE_DIRS and libexif_LIBRARIES will have
# includes and libraries paths.
#

if(NOT libexif_FOUND)

  find_path(LIBEXIF_ROOT_DIR
      NAMES "include/libexif/exif-data.h"
      PATHS ${LIBEXIF_ROOT_DIR} ENV libexif_ROOT ENV EXIF_ROOT ENV EXIF_ROOT_DIR
      )

  find_path(libexif_INCLUDE_DIR
      NAMES "libexif/exif-data.h"
      HINTS ${LIBEXIF_ROOT_DIR} ${LIBEXIF_ROOT_DIR}/include
      PATH_SUFFIXES "include"
      )

  find_library(libexif_LIBRARY
      NAMES exif libexif libexifd
      HINTS ${LIBEXIF_ROOT_DIR}
      PATH_SUFFIXES "lib"
      )

  # EXISTS doesn't work on the system include path on linux. :(
  if(libexif_INCLUDE_DIR AND libexif_LIBRARY)
    set(libexif_FOUND TRUE)
  else()
    set(libexif_FOUND FALSE)
  endif()

  ### final check ###
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(libexif DEFAULT_MSG
      libexif_LIBRARY libexif_INCLUDE_DIR)

  # Set standard CMake FindPackage variables if found.
  if(libexif_FOUND)
    set(libexif_INCLUDE_DIRS "${libexif_INCLUDE_DIR}")
    set(libexif_LIBRARIES    "${libexif_LIBRARY}")
  endif()

  ### Create target.
  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.0 AND libexif_FOUND)
    message(STATUS "Creating exported libexif::libexif target: '${libexif_LIBRARY}'")
    add_library(libexif::libexif SHARED IMPORTED)
    set_target_properties(libexif::libexif PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES  ${libexif_INCLUDE_DIRS}
        IMPORTED_LOCATION              ${libexif_LIBRARIES}
        IMPORTED_IMPLIB                ${libexif_LIBRARIES}
        )
    set(libexif_INCLUDE_DIRS "")
    set(libexif_LIBRARIES libexif::libexif)

    # Only mark internal variables as advanced if we found package, otherwise
    # leave them visible in the standard GUI for the user to set manually.
    mark_as_advanced(FORCE libexif_INCLUDE_DIR libexif_LIBRARY)
  endif()

endif(NOT libexif_FOUND)
