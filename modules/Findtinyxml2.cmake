# Find TinyXML
#
# This sets the following variables:
# tinyxml2_FOUND
# tinyxml2_INCLUDE_DIRS
# tinyxml2_LIBRARIES

find_path(tinyxml2_INCLUDE_DIR tinyxml2.h
    PATHS "${CMAKE_INSTALL_PREFIX}/include"
    PATHS ${TINYXML2_DIR} ENV TINYXML2_DIR
    PATH_SUFFIXES "include"
)

set(tinyxml2_INCLUDE_DIRS "${tinyxml2_INCLUDE_DIR}")

find_library(tinyxml2_LIBRARY
    NAMES "tinyxml2" "libtinyxml2"
    PATHS "${CMAKE_INSTALL_PREFIX}/lib"
    PATHS ${TINYXML2_DIR} ENV TINYXML2_DIR
    PATH_SUFFIXES "lib"
)

set(tinyxml2_LIBRARIES "${tinyxml2_LIBRARY}")

add_library(tinyxml2::tinyxml2 SHARED IMPORTED)
set_target_properties(tinyxml2::tinyxml2 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES  ${tinyxml2_INCLUDE_DIRS})
set_target_properties(tinyxml2::tinyxml2 PROPERTIES IMPORTED_IMPLIB                ${tinyxml2_LIBRARIES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(tinyxml2 DEFAULT_MSG tinyxml2_INCLUDE_DIR)

mark_as_advanced(tinyxml2_INCLUDE_DIRS)
