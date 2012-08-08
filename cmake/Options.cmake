# Options (boolean variables) that the user can pass to Cmake.

if(NOT _OPTIONS_INCLUDED)
set(_OPTIONS_INCLUDED TRUE)

set(_ace "Don't use the bundled ACE sources, but search for ACE libraries")
set(_ace "${_ace} on your system.")

set(_tbb "Don't use the bundled TBB sources, but search for TBB libraries")
set(_tbb "${_tbb} on your system.")

set(_pch "Don't use precompiled headers, even if possible.")

option(DEBUG            "Compile with debug informations and checks."   0)
option(USE_STD_MALLOC   "Use standard malloc instead of TBB malloc."    0)
option(NOPCH            "${_pch}"                                       0)
option(ACE_USE_EXTERNAL "${_ace}"                                       0)
option(TBB_USE_EXTERNAL "${_tbb}"                                       0)

set(ACE_ROOT "$ENV{ACE_ROOT}" CACHE PATH "ACE install path.")
set(TBB_ROOT "$ENV{TBB_ROOT}" CACHE PATH "TBB install path.")
# See also Prefix.cmake for the PREFIX variable.

endif(NOT _OPTIONS_INCLUDED)