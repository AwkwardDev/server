# Find out the platform we are running on.
#
### Defined Variables
# PLATFORM, X86 or X64 or IPF64, 32BITS or 64BITS
# MULTICONFIG_GENERATOR or MAKEFILE_GENERATOR
# VISUAL_STUDIO

if(NOT _PLATFORM_INCLUDED)
set(_PLATFORM_INCLUDED TRUE)

if(CMAKE_SIZEOF_VOID_P MATCHES 8)
    if(WIN32)
      # This definition is necessary to work around a bug with Intellisense
      # described here: http://tinyurl.com/2cb428.
      add_definitions("-D_WIN64")
      set(64BITS TRUE)
      if($ENV{PROCESSOR_ARCHITECTURE} STREQUAL "AMD64")
        set(X64 TRUE)
        set(PLATFORM "X64")
        message(STATUS "Detected 64-bit x64 platform.")
      elseif($ENV{PROCESSOR_ARCHITECTURE} STREQUAL "IA64")
        set(IPF64 TRUE) # IPF = Itanium Processor Family
        set(PLATFORM "IPF64")
        message(STATUS "Detected 64-bit Itanium platform.")
      endif()
    else()
      execute_process(
        COMMAND uname -m
        OUTPUT_VARIABLE UNAME_M
        OUTPUT_STRIP_TRAILING_WHITESPACE
      )
      if(UNAME_M STREQUAL "x86_64")
        set(X64 TRUE)
      elseif(UNAME_M STREQUAL "ia64")
        set(IPF64 TRUE)
      else()
        message(FATAL_ERROR
          "uname -m output not recognized, or uname not found.")
      endif()
    endif()
elseif(CMAKE_SIZEOF_VOID_P MATCHES 4)
    set(PLATFORM "X86")
    set(32BITS TRUE)
    set(X86 TRUE)
    message(STATUS "Detected 32-bit platform.")
else()
    message(FATAL_ERROR "Pointers are neither 4 or 8 bytes. WTF ?")
endif()

if(CMAKE_GENERATOR MATCHES "Visual.*")
  set(VISUAL_STUDIO TRUE)
endif()
if(CMAKE_GENERATOR MATCHES "[^\\-]*Make.*")
  set(MAKEFILE_GENERATOR TRUE)
else()
  set(MULTICONFIG_GENERATOR TRUE)
endif()

endif(NOT _PLATFORM_INCLUDED)