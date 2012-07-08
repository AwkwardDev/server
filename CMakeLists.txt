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
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR
    "This project requires an out of source build. "
    "Remove the file 'CMakeCache.txt' and the folder 'CMakeFiles' found in "
    "this directory before continuing, create a separate build directory "
    "and run 'cmake <srcs> [options]' from there.")
endif()

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
  set(DEBUG FALSE)
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
  set(DEBUG FALSE)
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
  set(DEBUG TRUE)
eles()
  message(FATAL_ERROR "CMAKE_BUILD_TYPE must be 'Release' or 'Debug'")
endif()

include(Platform)
include(Prefix)
include(Options)
include(PCH)
find_package(Git)

# TODO -------------------------------------------------------------------------
set(VS100_FOUND YES)
# mingw OR if(WIN32 AND NOT MSVC)
#       message(FATAL_ERROR "Only Visual Studio is supported for Windows."
# dbghelp.dll, 32 bits only ?
# ------------------------------------------------------------------------------

#-- ACE & TBB ------------------------------------------------------------------

# Build on WIN32, find the libraires on unix.

if(WIN32)
  set(ACE_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/dep/acelite)
  set(ACE_LIBRARY "ace")
  set(HAVE_ACE_STACK_TRACE_H ON) # config.h.cmake
else()
  find_package(ACE REQUIRED)
endif()

if(NOT USE_STD_MALLOC)
  if(WIN32)
    include(cmake/ImportTBB.cmake)
  else()
    find_package(TBB REQUIRED)
  endif()
endif()

#           WINDOWS         UNIX
# ACE       compiled        external?
# TBB       compiled        external
# MySQL     pre-compiled    external
# OpenSSL   pre-compiled    external
# ZLIB      compiled        external

#-- MySQL, OpenSSL & ZLIB ------------------------------------------------------

# Win32 has pre-compiled libraries, find the libraries on unix.
if(WIN32)
  set(MYSQL_INCLUDE_DIR
    ${CMAKE_SOURCE_DIR}/dep/include/mysql)
  set(MYSQL_LIBRARY
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libmySQL.lib)
  set(MYSQL_DEBUG_LIBRARY
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libmySQL.lib)
  set(OPENSSL_INCLUDE_DIR
    ${CMAKE_SOURCE_DIR}/dep/include/openssl)
  set(OPENSSL_LIBRARIES
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libeay32.lib)
  set(OPENSSL_DEBUG_LIBRARIES
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libeay32.lib)
elseif(UNIX)
  find_package(MySQL REQUIRED)
  find_package(OpenSSL REQUIRED)
  find_package(ZLIB REQUIRED)
endif()

if(WIN32)
  install(
    FILES
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libeay32.dll
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libmySQL.dll
    DESTINATION ${BIN_DIR}
    CONFIGURATIONS Release
  )
  install(
    FILES
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libeay32.dll
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libmySQL.dll
    DESTINATION ${BIN_DIR}
    CONFIGURATIONS Debug
  )
endif()

#-------------------------------------------------------------------------------

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
  if(NOT GIT_RESULT)
    set(GIT_REVISION "Git repository not found.")
  endif()
else()
  set(GIT_REVISION "Git not found.")
endif()

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/revision.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/revision.h)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/config.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include(CompilerFlags)
include(PrintConfig)

add_subdirectory(dep)
add_subdirectory(src)
