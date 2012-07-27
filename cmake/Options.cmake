# Options (boolean variables) that the user can pass to Cmake.

if(NOT _OPTIONS_INCLUDED)
set(_OPTIONS_INCLUDED TRUE)

option(DEBUG            "Debug mode."                           0)
option(TBB_USE_EXTERNAL "Use external TBB."                     0)
option(ACE_USE_EXTERNAL "Use external ACE."                     0)
option(USE_STD_MALLOC   "Use standard malloc instead of TBB."   0)
option(NOPCH            "Don't use PCH even if possible."       0)

endif(NOT _OPTIONS_INCLUDED)

# Other variables the user might wish to customize:
#
# PREFIX : The path to the install directory (relative to the source directory,
#   or absolute).