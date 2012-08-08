# Find the ACE client includes and libraries.
# This module defines
# ACE_INCLUDE_DIR, where to find ace.h
# ACE_LIBRARY, the library to link against
# ACE_FOUND, if false, you cannot build anything that requires ACE

if(NOT _FIND_HANDLE_INCLUDED)
  message(FATAL_ERROR "FindPackageHandleStandardArgs.cmake not included.")
endif()

find_path(ACE_INCLUDE_DIR NAMES ace/ACE.h PATHS
    "/usr/include"
    "/usr/include/ace"
    "/usr/local/include"
    "/usr/local/include/ace"
    "${ACE_ROOT}"
    "${ACE_ROOT}/include"
    "$ENV{ACE_ROOT}"
    "$ENV{ACE_ROOT}/include")

find_library(ACE_LIBRARY NAMES ace ACE PATHS
    "/usr/lib"
    "/usr/lib/ace"
    "/usr/local/lib"
    "/usr/local/lib/ace"
    "/usr/local/ace/lib"
    "${ACE_ROOT}"
    "${ACE_ROOT}/lib"
    "$ENV{ACE_ROOT}"
    "$ENV{ACE_ROOT}/lib")

if(ACE_INCLUDE_DIR)
  message(STATUS "Found ACE headers: ${ACE_INCLUDE_DIR}")
endif()
if(ACE_LIBRARY)
  message(STATUS "Found ACE library: ${ACE_LIBRARY}")
endif()

find_package_handle_standard_args(ACE
  "Could not find ACE headers or library. Please install them."
  ACE_INCLUDE_DIR
  ACE_LIBRARY)