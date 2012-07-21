add_definitions("/D__TBBMALLOC_BUILD=1")

if(WIN32)
  add_definitions("/DUSE_WINTHREAD") # TBB-specific
  if(MSVC)
    add_definitions(
      # TBB-specific
      "/DDO_ITT_NOTIFY"
      # This implies _CRT_SECURE_NO_WARNINGS on newer versions.
      "/D_CRT_SECURE_NO_DEPRECATE"
      # "forcing value to bool 'true' or 'false' (perf warning)"
      "/wd4800")
  elseif(MINGW)
    add_definitions(
      "-D_WIN32_WINNT=0x0501"
      "-DMINGW_HAS_SECURE_API=1"
      "-D__MSVCRT_VERSION__=0x0700"
      "-msse"
      "-mthreads"
      "-m32"
      "-march=i686"
      "-fno-rtti"
      "-fno-exceptions"
      "-Wno-parentheses"
      "-Wno-uninitialized"
      )
  endif()
endif()

if(32BITS)
  if(WIN32)
    if(CMAKE_COMPILER_IS_GNUCC)
      set(      tbbmalloc_DEF   def/win32-gcc.def)
    else()
      set(      tbbmalloc_DEF   def/win32.def)
    endif()
    file(GLOB   tbbmalloc_ASM   asm/ia32-masm/*)
  elseif(LINUX)
    set(        tbbmalloc_DEF   def/lin32.def)
  elseif(APPLE)
    set(        tbbmalloc_DEF   def/mac32.def)
  endif()
elseif(64BITS)
  if(WIN32)
    if(CMAKE_COMPILER_IS_GNUCC)
      set(      tbbmalloc_DEF   def/win64-gcc.def)
    else()
      set(      tbbmalloc_DEF   def/win64.def)
    endif()
    file(GLOB   tbbmalloc_ASM   asm/intel64-masm/*)
  elseif(LINUX)
    if(IPF64)
      file(GLOB tbbmalloc_ASM   asm/ia64-gas/*)
    endif()
    set(        tbbmalloc_DEF   def/lin64.def)
  elseif(APPLE)
    set(        tbbmalloc_DEF   def/mac64.def)
  endif()
endif()

set(tbbmalloc_SRCS
  src/backend.cpp
  src/backref.cpp
  src/frontend.cpp
  src/large_objects.cpp
  src/tbbmalloc.cpp
  src/itt_notify.cpp
  ${tbbmalloc_ASM}
  ${tbbmalloc_DEF}
)

include_directories(. ..)

add_library(tbbmalloc SHARED ${tbbmalloc_SRCS})
install(TARGETS tbbmalloc RUNTIME DESTINATION "${BIN_DIR}")