# - Find the native exiv2 includes and library
# create package exiv2

# This module will set the following variables:
#
#  exiv2_FOUND          - True if exiv2 library is found.
#  exiv2_INCLUDE_DIRS   - Where to find exiv2/image.hpp header files.
#  exiv2_LIBRARIES      - Libraries to be linked with executable.
#
# This module tries to create the target "exiv2::exiv2" that may be used
# when building executables and libraries via target_link_libraries(my_module).
# In this case exiv2_INCLUDE_DIRS will be empty and exiv2_LIBRARIES will
# get the target name to be sure that target is activated properly.
# For old CMake versions exiv2_INCLUDE_DIRS and exiv2_LIBRARIES will have
# includes and libraries paths.
#


if(NOT exiv2_FOUND)

    if(WIN32)
        find_package(expat REQUIRED)
        find_package(iconv REQUIRED)
        find_package(zlib REQUIRED)
    endif(WIN32)

    find_path(EXIV2_ROOT_DIR
        NAMES "include/exiv2/image.hpp"
        HINTS ${exiv2_INCLUDE_DIR}/..
        PATHS ${EXIV2_ROOT_DIR} 
            ENV exiv2_ROOT 
            ENV EXIV_ROOT
    )

    find_path(exiv2_INCLUDE_DIR
        NAMES
            exiv2/image.hpp
        HINTS
            ${EXIV2_ROOT_DIR}
            ${exiv2_INCLUDE_DIR}
            ${exiv2_INCLUDE_DIRS}
        PATH_SUFFIXES "include"
    )

    set(EXIV2_NAMES ${EXIV2_NAMES} exiv2 libexiv2)
    find_library(exiv2_LIBRARY
        NAMES ${EXIV2_NAMES}
        PATHS ${EXIV2_ROOT_DIR}
        PATH_SUFFIXES "lib"
    )

    if(WIN32)
        find_library(EXIV2_XMP_LIBRARY 
            NAMES exiv2-xmp
            HINTS ${EXIV2_ROOT_DIR}
            PATH_SUFFIXES "lib"
        )
    endif(WIN32)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(exiv2 DEFAULT_MSG exiv2_LIBRARY exiv2_INCLUDE_DIR)

    if(exiv2_VERSION VERSION_LESS exiv2_FIND_VERSION)
        message(FATAL_ERROR "Exiv2 version check failed.  Version ${exiv2_VERSION} was found, at least version ${exiv2_FIND_VERSION} is required")
    endif(exiv2_VERSION VERSION_LESS exiv2_FIND_VERSION)

    # Set standard CMake FindPackage variables if found.
    if(exiv2_FOUND)
        set(exiv2_INCLUDE_DIRS "${exiv2_INCLUDE_DIR}")
        set(exiv2_LIBRARIES    "${exiv2_LIBRARY}")
    endif()

    ### Create target.
    if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.0 AND exiv2_FOUND)
        message(STATUS "Creating exported exiv2::exiv2 target: '${exiv2_LIBRARY}'")

        add_library(exiv2::exiv2 SHARED IMPORTED)
        set_target_properties(exiv2::exiv2 PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES  ${exiv2_INCLUDE_DIRS}
            IMPORTED_LOCATION              ${exiv2_LIBRARIES}
            IMPORTED_IMPLIB                ${exiv2_LIBRARIES}
        )
        if(WIN32)
            target_link_libraries(exiv2::exiv2 INTERFACE ${EXIV2_XMP_LIBRARY} ZLIB::ZLIB Iconv::Iconv EXPAT::EXPAT Psapi)
        endif(WIN32)

        set(exiv2_INCLUDE_DIRS "")
        set(exiv2_LIBRARIES exiv2::exiv2)

        # Only mark internal variables as advanced if we found package, otherwise
        # leave them visible in the standard GUI for the user to set manually.
        mark_as_advanced(FORCE exiv2_INCLUDE_DIR exiv2_LIBRARY)
    endif()
endif(NOT exiv2_FOUND)
