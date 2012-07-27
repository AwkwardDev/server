if(NOT _COMPILERFLAGS_INCLUDED)
set(_COMPILERFLAGS_INCLUDED)

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

# Set important macros.
set(_defs_release _RELEASE _NDEBUG)
set(_defs_debug _DEBUG MANGOS_DEBUG)
if(WIN32)
  set(_defs WIN32 _WIN32)
  list(APPEND _defs_release _CRT_SECURE_NO_WARNINGS)
endif()
set_directory_properties(PROPERTIES
  COMPILE_DEFINITIONS           "${_defs}"
  COMPILE_DEFINITIONS_RELEASE   "${_defs_release}"
  COMPILE_DEFINITIONS_DEBUG     "${_defs_debug}")

endif(NOT _COMPILERFLAGS_INCLUDED)