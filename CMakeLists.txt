# Copyright (C) 2005-2011 MaNGOS <http://getmangos.com/>
# Copyright (C) 2009-2011 MaNGOSZero <https://github.com/mangos-zero>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

project(Silverpine)
set(SILVERPINE_VERSION 0.6.1)
cmake_minimum_required(VERSION 2.8)

# Where to find our modules (for find_package(...) and include(...)).
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Force out-of-source build.
if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR
    "This project requires an out of source build. "
    "Remove the file 'CMakeCache.txt' and the folder 'CMakeFiles' found in "
    "this directory before continuing, create a separate build directory "
    "and run 'cmake <srcs> [options]' from there.")
endif()

if(DEBUG)
  set(CMAKE_BUILD_TYPE "Debug"   CACHE STRING "Use DEBUG instead." FORCE)
else()
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Use DEBUG instead." FORCE)
endif()

include(Platform)
include(Prefix)
include(Options)
include(PCH)
include(Dependencies)
include(CompilerFlags)
find_package(Git)

# Find the git revision (HEAD commit) hashstring and date.
if(GIT_EXECUTABLE)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} log -1 --format="%H"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    OUTPUT_VARIABLE GIT_HASHSTRING
    RESULT_VARIABLE GIT_RESULT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  execute_process(
    COMMAND ${GIT_EXECUTABLE} log -1 --format="%cd"
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    OUTPUT_VARIABLE GIT_DATETIME
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if(GIT_RESULT) # if errorcode (GIT_RESULT != 0)
    set(GIT_HASHSTRING "\"Git repository not found.\"")
  endif()
else()
  set(GIT_HASHSTRING "\"Git not found.\"")
endif()

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/revision.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/revision.h)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include(PrintConfig)

add_subdirectory(dep)
add_subdirectory(src)
