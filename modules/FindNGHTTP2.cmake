# - Find nghttp2
# Find the nghttp2 libraries
#
# This module defines the following variables:
#
#   NGHTTP2_FOUND       : True if nghttp2 is found
#   NGHTTP2_INCLUDE_DIRS: set when NGHTTP2_INCLUDE_DIR found
#   NGHTTP2_LIBRARIES   : the library to link against.
#
# The following :prop_tgt:`IMPORTED` target is also defined::
#
#   NGHTTP2::nghttp2
#
# Example to find NGHTTP2:
#
#   find_package(NGHTTP2 REQUIRED)
#   add_executable(foo foo.cc)
#	target_link_libraries(foo
#		...
#		NGHTTP2::nghttp2
#		)

cmake_minimum_required(VERSION 3.11)

if(NOT NGHTTP2_FOUND)

  set(NGHTTP2_INCLUDE_DIR NOTFOUND)
  find_path(NGHTTP2_INCLUDE_DIR
            nghttp2/nghttp2.h
            PATH_SUFFIXES nghttp2
            PATHS ${NGHTTP2_ROOT}/include
            )

  set(NGHTTP2_ERROR_REASON)
  if(NOT NGHTTP2_INCLUDE_DIR)
    string(APPEND
           NGHTTP2_ERROR_REASON
           "Include dir for NGHTTP2 module not found. Set NGHTTP2_ROOT to the location of NGHTTP2."
           )
  else()
    set(NGHTTP2_INCLUDE_DIRS ${NGHTTP2_INCLUDE_DIR})
  endif()

  set(NGHTTP2_LIBRARY NOTFOUND)
  find_library(NGHTTP2_LIBRARY
               NAME	nghttp2
               PATHS ${NGHTTP2_ROOT}
               )
  set(NGHTTP2_ASIO_LIBRARY NOTFOUND)
  find_library(NGHTTP2_ASIO_LIBRARY
          NAME	nghttp2_asio
          PATHS ${NGHTTP2_ROOT}
          )
  if(NOT NGHTTP2_LIBRARY)
    string(APPEND
           NGHTTP2_ERROR_REASON
           "Library for NGHTTP2 module not found. Set NGHTTP2_ROOT to the location of NGHTTP2."
           )
  else()
    set(NGHTTP2_LIBRARIES ${NGHTTP2_LIBRARY})
  endif()

  set(NGHTTP2_VERSION_FILE NOTFOUND)
  find_file(NGHTTP2_VERSION_FILE
            nghttp2ver.h
            PATH_SUFFIXES nghttp2
            PATHS ${NGHTTP2_ROOT}/include
            )
  set(NGHTTP2_VERSION NOTFOUND)
  if(NGHTTP2_VERSION_FILE)
    file(READ ${NGHTTP2_VERSION_FILE} VERSION_FILE_CONTENT)
    string(REGEX REPLACE ".*#define NGHTTP2_VERSION \"*([0-9.])"   "\\1" VERSION_FILE_CONTENT ${VERSION_FILE_CONTENT})
    string(REGEX REPLACE "\".*"   "" NGHTTP2_VERSION ${VERSION_FILE_CONTENT})
  else()
    string(APPEND
           NGHTTP2_ERROR_REASON
           "NGHTTP2 version not found."
           )
  endif()

  if(NGHTTP2_LIBRARIES AND NGHTTP2_INCLUDE_DIRS AND NGHTTP2_VERSION)
    set(NGHTTP2_FOUND TRUE)
  endif()

  if (nghttp2_asio IN_LIST NGHTTP2_FIND_COMPONENTS AND NOT NGHTTP2_ASIO_LIBRARY)
    set(NGHTTP2_FOUND FALSE)
    string(APPEND
            NGHTTP2_ERROR_REASON
            "Library for nghttp2_asio component not found. Ensure that NGHTTP2 was built/installed with asio module."
            )
  endif()

  if(NGHTTP2_FOUND)
    if(NOT TARGET NGHTTP2::nghttp2)
      add_library(NGHTTP2::nghttp2 INTERFACE IMPORTED)
      set_target_properties(NGHTTP2::nghttp2
                            PROPERTIES
                            INTERFACE_INCLUDE_DIRECTORIES ${NGHTTP2_INCLUDE_DIRS}
                            INTERFACE_LINK_LIBRARIES "${NGHTTP2_LIBRARIES}"
                            )
    endif()
    if(NOT TARGET NGHTTP2::nghttp2_asio AND NGHTTP2_ASIO_LIBRARY)
      add_library(NGHTTP2::nghttp2_asio INTERFACE IMPORTED)
      set_target_properties(NGHTTP2::nghttp2_asio
              PROPERTIES
              INTERFACE_INCLUDE_DIRECTORIES ${NGHTTP2_INCLUDE_DIRS}
              INTERFACE_LINK_LIBRARIES "${NGHTTP2_ASIO_LIBRARY}"
              )
    endif()

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(NGHTTP2
                                      REQUIRED_VARS NGHTTP2_LIBRARY NGHTTP2_INCLUDE_DIR
                                      FOUND_VAR NGHTTP2_FOUND
                                      VERSION_VAR NGHTTP2_VERSION
                                      )

  else()
      message(SEND_ERROR "Unable to find the requested NGHTTP2 libraries.\n${NGHTTP2_ERROR_REASON}")
  endif()

endif(NOT NGHTTP2_FOUND)