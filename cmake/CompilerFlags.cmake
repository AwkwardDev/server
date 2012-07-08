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
  # Disable warnings in Visual Studio 8 and above and add /MP (build with
  # multiple processes).
  if(MSVC AND NOT CMAKE_GENERATOR MATCHES "Visual Studio 7")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}
        /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /MP")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}
        /wd4996 /wd4355 /wd4244 /wd4267 /MP")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}
        /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /MP")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}
        /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /MP")
  endif()
endif()

# Some small tweaks for Visual Studio 7 and above.
if(MSVC)
  # Mark 32 bit executables large address aware so they can use > 2GB address space
  if(PLATFORM MATCHES X86)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
  endif()
endif()