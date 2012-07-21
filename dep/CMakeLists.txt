if(NOT USE_STD_MALLOC)
  add_subdirectory(tbbmalloc)
endif()

add_subdirectory(src)
add_subdirectory(acelite)
