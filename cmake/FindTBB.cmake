# Find the Intel Threading Building Blocks includes and libraries.
# This module defines
# TBB_INCLUDE_DIR, where to find ptlib.h, etc.
# TBB_LIBRARIES, the libraries to link against to use pwlib.
# TBB_FOUND, If false, don't try to use pwlib.

set(TBB_FOUND NO)

if(UNIX)
  find_path(TBB_INCLUDE_DIR
    NAMES
      tbb/task_scheduler_init.h
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

  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    find_library(TBB_LIBRARY
        tbb_debug
        PATHS ${TBB_LIBRARY_PATHS}
    )
    find_library(TBB_MALLOC_LIBRARY
        tbbmalloc_debug
        PATHS ${TBB_LIBRARY_PATHS}
    )
  else()
    find_library(TBB_LIBRARY
        tbb
        PATHS ${TBB_LIBRARY_PATHS}
    )
    find_library(TBB_MALLOC_LIBRARY
        tbbmalloc
        PATHS ${TBB_LIBRARY_PATHS}
    )
  endif()

  set(TBB_LIBRARIES ${TBB_LIBRARY} ${TBB_MALLOC_LIBRARY})

  if(TBB_INCLUDE_DIR)
    message(STATUS "Found TBB headers: ${TBB_INCLUDE_DIR}")
  endif()
  if(TBB_LIBRARY AND TBB_MALLOC_LIBRARY)
    message(STATUS "Found TBB library: ${TBB_LIBRARIES}")
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(TBB
    "Could not find TBB headers or library. Please install them."
    TBB_INCLUDE_DIR
    TBB_LIBRARIES
  )
  endif()
endif()
