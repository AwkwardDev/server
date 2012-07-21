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

#-- Macro Definitions ----------------------------------------------------------

set(DEFINITIONS
  DO_MYSQL
  HAVE_CONFIG_H
  VERSION="${SILVERPINE_VERSION}"
  SYSCONFDIR="${CONF_DIR}/"
)

set(DEFINITIONS_RELEASE NDEBUG)
set(DEFINITIONS_DEBUG _DEBUG MANGOS_DEBUG)

if(WIN32)
  set(DEFINITIONS ${DEFINITIONS} WIN32 _WIN32)
  set(DEFINITIONS_RELEASE ${DEFINITIONS_RELEASE} _CRT_SECURE_NO_WARNINGS)
endif()

if(USE_STD_MALLOC)
  set(DEFINITIONS ${DEFINITIONS} USE_STANDARD_MALLOC)
endif()

set_directory_properties(PROPERTIES COMPILE_DEFINITIONS
  "${DEFINITIONS}")
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_RELEASE
  "${DEFINITIONS_RELEASE}")
set_directory_properties(PROPERTIES COMPILE_DEFINITIONS_DEBUG
  "${DEFINITIONS_DEBUG}")

#-------------------------------------------------------------------------------

if(WIN32)
  # To access some headers via <project_name>/<header_name>.h.
  include_directories(${CMAKE_SOURCE_DIR}/dep/include)
endif()

add_subdirectory(framework)
add_subdirectory(shared)
add_subdirectory(realmd)
add_subdirectory(game)
add_subdirectory(mangosd)
add_subdirectory(scripts)