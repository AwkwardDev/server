if(NOT USE_STD_MALLOC AND NOT TBB_USE_EXTERNAL)
  add_subdirectory(tbbmalloc)
endif()

if(NOT ACE_USE_EXTERNAL)
  add_subdirectory(acelite)
endif()

add_subdirectory(src)
