#
# This file has a collection of build options for the MSVC compiler that
#   we have found so far for normal working of used open-source libraries.
#
# Any new module that will require specific options for MSVC should be added here.
#

# Unfortunately parallel building is off by default
add_definitions("/MP")

# Many targets overflow default size of object files with last packages,
#   so we allow all our targets to have huge objs
add_definitions("/bigobj")

# To omit definition of min/max macros in the windows.h that disturbs to
#   std::max/std::min expressions for MSVC compiler
add_definitions("-DNOMINMAX")

# MSVC floating point model: "strict" helped to unify results on different compiler versions
# For more info look at: https://msdn.microsoft.com/en-us/library/e7s85ffb%28v=vs.120%29.aspx
#
add_definitions("/fp:strict")

# Boost requires this because of removed std::unary_function since /std:c++14,
# see https://stackoverflow.com/questions/41972522
#
add_definitions("-D_HAS_AUTO_PTR_ETC=1")

set(Boost_USE_STATIC_LIBS ON CACHE BOOL "" FORCE)

if (NOT Boost_USE_STATIC_LIBS)
  add_definitions("-DBOOST_SYSTEM_DYN_LINK")
  add_definitions("-DBOOST_FILESYSTEM_DYN_LINK")
  add_definitions("-DBOOST_PROGRAM_OPTIONS_DYN_LINK")
# add_definitions(${Boost_LIB_DIAGNOSTIC_DEFINITIONS})
endif()

# gtest module should use dynamic CRT libraries by default on windows.
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# TBB library adds in two headers one of the tbb.lib or tbb_debug.lib depending
#   on the _DEBUG definition. But the problem is that the configuration
#   RelWithDebInfo doesn't have _DEBUG and hence it's wrong.
#   Thus we turn off this feature in TBB by adding the definition below.
#
# Source: https://github.com/justusc/FindTBB/issues/8
#
add_definitions("-D__TBB_NO_IMPLICIT_LINKAGE")
