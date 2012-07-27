# See the CMakeLists.txt in this directory.

set(_config_files
  "mangosd.conf"
  "realmd.conf"
  "scriptdevzero.conf")

foreach(_file ${_config_files})
  set(_src "${_CONFIG_DIR}/${_file}")
  set(_dst "${_BUILD_BINDIR}/../etc/")
  if(EXISTS "${_src}")
    file(MAKE_DIRECTORY "${_dst}")
    file(COPY "${_src}" DESTINATION "${_dst}")
  endif()
endforeach()
