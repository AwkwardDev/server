# Copyright (C) 2006-2011 ScriptDev2 <http://www.scriptdev2.com/>
# Copyright (C) 2010-2011 ScriptDev0 <http://github.com/mangos-zero/scriptdev0>
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

## magic to include revision data in SD0 version string
# revision.h: FORCE
#   $(top_builddir)/src/tools/genrevision/genrevision $(srcdir)

file(GLOB_RECURSE mangosscript_SRCS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp *.h)

source_group("Other" REGULAR_EXPRESSION .*)

foreach(SRC ${mangosscript_SRCS})
  get_filename_component(PTH ${SRC} PATH)
  if(PTH)
    if(NOT XCODE) # FIXME: Xcode Generator has bug with nested dirs
      string(REPLACE "/" "\\\\" PTH ${PTH})
    endif()
    source_group(${PTH} FILES ${SRC})
  endif()
endforeach(SRC)

include_directories(
  "${CMAKE_CURRENT_SOURCE_DIR}/base"
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
  "${CMAKE_SOURCE_DIR}/src/shared"
  "${CMAKE_SOURCE_DIR}/src/framework"
  "${CMAKE_SOURCE_DIR}/src/game"
  "${CMAKE_SOURCE_DIR}/dep/include"
  "${CMAKE_BINARY_DIR}"
  "${ACE_INCLUDE_DIR}"
  "${MYSQL_INCLUDE_DIR}"
  "${TBB_INCLUDE_DIR}")

add_library(mangosscript SHARED ${mangosscript_SRCS})

if(WIN32)
  # Location of mangosd.lib.
  link_directories(${CMAKE_BINARY_DIR}/src/mangosd/${CMAKE_CFG_INTDIR})
  target_link_libraries(mangosscript
    mangosd # FIXME: could this be done for unix? because unix won't generate exe.libs
  )
endif()

add_dependencies(mangosscript revision.h)

if(NOT ACE_USE_EXTERNAL)
  add_dependencies(mangosscript ace)
  target_link_libraries(mangosscript "${ACE_LIBRARY}")
endif()

if(NOT USE_STD_MALLOC)
  if(NOT TBB_USE_EXTERNAL)
    add_dependencies(mangosscript tbbmalloc)
  endif()
  target_link_libraries(mangosscript "${TBB_LIBRARY}")
endif()

if(UNIX)
  set(mangosscript_LINK_FLAGS "-pthread")
  if(APPLE)
    set(mangosscript_LINK_FLAGS "-framework Carbon ${mangosscript_LINK_FLAGS}")
    # Needed for the linking because of the missing symbols
    set(mangosscript_LINK_FLAGS "-Wl,-undefined -Wl,dynamic_lookup ${mangosscript_LINK_FLAGS}")
  endif()

  if(APPLE)
    set(mangosscript_PROPERTIES INSTALL_NAME_DIR "${BIN_DIR}")
  else()
    set(mangosscript_PROPERTIES INSTALL_RPATH ${BIN_DIR})
  endif()

  set_target_properties(mangosscript PROPERTIES
    LINK_FLAGS ${mangosscript_LINK_FLAGS}
    ${mangosscript_PROPERTIES})
endif()

add_precompiled_header(mangosscript
  "${CMAKE_CURRENT_SOURCE_DIR}/include/precompiled.h")

install(TARGETS mangosscript DESTINATION "${BIN_DIR}")

set(_distfile "${CMAKE_BINARY_DIR}/config/scriptdevzero.conf.dist")
configure_file("scriptdevzero.conf.dist.in" "${_distfile}")
install(FILES "${_distfile}" DESTINATION "${CONF_DIR}")
_install_pdb_file(mangosscript "${BIN_DIR}")