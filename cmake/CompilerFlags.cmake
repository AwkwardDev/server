# Handle debugmode compiles (this will require further work for proper WIN32-setups)
if(UNIX)
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
endif()

if(UNIX)
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} --no-warnings")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} --no-warnings")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Wall -Wfatal-errors -Wextra")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wfatal-errors -Wextra")
elseif(WIN32)
  if(MSVC)
    list(APPEND CMAKE_C_FLAGS
        "/wd4996"   # deprecated functions
        "/wd4244"   # unsafe integer conversions
        "/wd4267"   # unsafe conversion from source type size_t
        "/MP"       # build with multiple processes
    )
    list(APPEND CMAKE_CXX_FLAGS
        "/wd4996"   # deprecated functions
        "/wd4244"   # unsafe integer conversions
        "/wd4267"   # unsafe conversion from source type size_t
        # allows passing "this" to base-class and class member constructors
        "/wd4355"
        "/MP"       # build with multiple processes
    )
    string(REPLACE ";" " " CMAKE_C_FLAGS    "${CMAKE_C_FLAGS}")
    string(REPLACE ";" " " CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS}")
  endif()
endif()

# Allow MSVC 32bit executables to use more than 2GB address space.
if(MSVC AND X86)
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
endif()