# Find the Intel Threading Building Blocks includes and libraries.
# This module defines
# TBB_INCLUDE_DIR, where to find scalabe_allocator.h.
# TBB_LIBRARY, the library to link against.

set(TBB_FOUND NO)

if(UNIX)
  find_path(TBB_INCLUDE_DIR
    NAMES
      tbb/scalable_allocator.h
    PATHS
      /usr/local/include
      /usr/include
      ${TBB_ROOT}
      ${TBB_ROOT}/include
      $ENV{TBB_ROOT}
      $ENV{TBB_ROOT}/include
  )
  set(TBB_LIBRARY_PATHS
      /usr/local/lib
      /usr/lib
      ${TBB_ROOT}
      ${TBB_ROOT}/lib
      $ENV{TBB_ROOT}
      $ENV{TBB_ROOT}/lib
  )
  find_library(TBB_LIBRARY
      tbbmalloc
      PATHS ${TBB_LIBRARY_PATHS}
  )

  if(TBB_INCLUDE_DIR)
    message(STATUS "Found TBB malloc headers: ${TBB_INCLUDE_DIR}")
  endif()
  if(TBB_LIBRARY)
    message(STATUS "Found TBB malloc library: ${TBB_LIBRARY}")
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(TBB
    "Could not find TBB headers or library. Please install them."
    TBB_INCLUDE_DIR
    TBB_LIBRARY
  )
  endif()
endif()
