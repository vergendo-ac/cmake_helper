# - Try to find systemd
# Once done this will define
#  SYSTEMD_FOUND        - System has systemd
#  SYSTEMD_INCLUDE_DIRS - The systemd include directories
#  SYSTEMD_LIBRARIES    - The libraries needed to use systemd

if(NOT SYSTEMD_FOUND)
  include(FeatureSummary)
  set_package_properties(Systemd PROPERTIES
          URL "http://freedesktop.org/wiki/Software/systemd/"
          DESCRIPTION "System and Service Manager")

  find_package(PkgConfig QUIET)
  pkg_check_modules(PC_SYSTEMD QUIET libsystemd)
  find_library(SYSTEMD_LIBRARIES NAMES systemd ${PC_SYSTEMD_LIBRARY_DIRS})
  find_path(SYSTEMD_INCLUDE_DIRS systemd/sd-login.h HINTS ${PC_SYSTEMD_INCLUDE_DIRS})

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(SYSTEMD DEFAULT_MSG SYSTEMD_INCLUDE_DIRS SYSTEMD_LIBRARIES)
  mark_as_advanced(SYSTEMD_INCLUDE_DIRS SYSTEMD_LIBRARIES)

  add_library(systemd::systemd SHARED IMPORTED)
  set_target_properties(systemd::systemd PROPERTIES
          INTERFACE_INCLUDE_DIRECTORIES  ${SYSTEMD_INCLUDE_DIRS}
          IMPORTED_LOCATION              ${SYSTEMD_LIBRARIES}
          IMPORTED_IMPLIB                ${SYSTEMD_LIBRARIES}
          )
endif()
