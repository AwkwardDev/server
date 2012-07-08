# Find out the platform we are running on.
#
### Defined Variables
# PLATFORM, X86 or X64

if(CMAKE_SIZEOF_VOID_P MATCHES 8)
    message(STATUS "Detected 64-bit platform.")
    # This definition is necessary to work around a bug with Intellisense
    # described here: http://tinyurl.com/2cb428.
    if(WIN32)
      add_definitions("-D_WIN64")
    endif()
    set(PLATFORM X64)
elseif(CMAKE_SIZEOF_VOID_P MATCHES 4)
    message(STATUS "Detected 32-bit platform.")
    set(PLATFORM X86)
else()
    message(FATAL_ERROR "The platform is neither x86 or x64.")
endif()