# This file is loaded before the CMake configure step. It allows to set cache
# variables before CMake starts doing its usual routine, thereby allowing to
# influence what CMake does between the time when it starts its usual routine
# and the time it read the main CMakeLists.txt.
#
# This enable to do in one CMake invocation things that would normally have
# required two: one to set the variables then one to apply the modified
# behaviour. Exemple of such use are setting the generator and setting the
# configuration types.
#
# The preloading of the file "PreLoad.cmake" is a standard but undocumented
# feature of CMake.
# http://public.kitware.com/Bug/view.php?id=802

set(CMAKE_CONFIGURATION_TYPES "Release;Debug" CACHE INTERNAL
  "Only valid configuration types" FORCE)