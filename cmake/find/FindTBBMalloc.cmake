# Find the Intel Threading Building Blocks malloc library and includes.
# This module defines
# TBBMalloc_INCLUDE_DIR, where to find scalable_allocator.h.
# TBBMalloc_LIBRARY, the library to link against.
# TBBMalloc_FOUND, if false, you cannot build anything that requires TBB malloc.

if(NOT _FIND_HANDLE_INCLUDED)
  message(FATAL_ERROR "FindPackageHandleStandardArgs.cmake not included.")
endif()

find_path(TBBMalloc_INCLUDE_DIR NAMES tbb/scalable_allocator.h PATHS
    "${TBB_ROOT}"
    "${TBB_ROOT}/include"
    "/usr/local/include"
    "/usr/include")

set(TBBMalloc_LIBRARY_PATHS
    "${TBB_ROOT}"
    "${TBB_ROOT}/lib"
    "/usr/local/lib"
    "/usr/lib")

find_library(TBBMalloc_LIBRARY tbbmalloc PATHS ${TBBMalloc_LIBRARY_PATHS})

if(TBBMalloc_INCLUDE_DIR)
  message(STATUS "Found TBB malloc headers: ${TBBMalloc_INCLUDE_DIR}")
endif()
if(TBBMalloc_LIBRARY)
  message(STATUS "Found TBB malloc library: ${TBBMalloc_LIBRARY}")
endif()

find_package_handle_standard_args(TBB
  "Could not find TBB malloc headers or library. Please install them."
  TBBMalloc_INCLUDE_DIR
  TBBMalloc_LIBRARY)
