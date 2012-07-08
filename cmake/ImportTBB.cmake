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

if(WIN32)
  set(LIB_SUFFIX dll)
  if(VS100_FOUND)
    set(VSDIR vs100project)
  else()
    set(VSDIR vsproject)
  endif()
  if(PLATFORM MATCHES X86)
    set(ARCHDIR ia32)
  else()
    set(ARCHDIR intel64)
  endif()
  set(TBB_LIBRARIES_DIR
    ${CMAKE_SOURCE_DIR}/dep/tbb/build/${VSDIR}/${ARCHDIR}/Release
    ${CMAKE_SOURCE_DIR}/dep/tbb/build/${VSDIR}/${ARCHDIR}/Debug
  )
else()
  if(APPLE)
    set(LIB_SUFFIX dylib)
  else()
    set(LIB_SUFFIX so)
  endif()
  set(TBB_LIBRARIES_DIR
    ${CMAKE_SOURCE_DIR}/dep/tbb/build/libs_release
    ${CMAKE_SOURCE_DIR}/dep/tbb/build/libs_debug
  )
endif()

set(TBB_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/dep/tbb/include)
set(TBB_LIBRARIES
  optimized tbb
  optimized tbbmalloc
  debug tbb_debug
  debug tbbmalloc_debug)

# Create directories to avoid warnings due to inexistant directories.
if(XCODE)
  foreach(DIR ${TBB_LIBRARIES_DIR})
    foreach(CONF ${CMAKE_CONFIGURATION_TYPES})
      file(MAKE_DIRECTORY ${DIR}/${CONF})
    endforeach()
  endforeach()
endif()

link_directories(
  ${TBB_LIBRARIES_DIR}
)

# To install, move generated dll files to the BIN_DIR.
foreach(DIR ${TBB_LIBRARIES_DIR})
  install(
    DIRECTORY ${DIR}/ DESTINATION ${BIN_DIR}
    FILES_MATCHING PATTERN "*.${LIB_SUFFIX}*"
  )
endforeach()