# Defines a few useful command missing from CMake built-ins.

if(NOT _UTILS_INCLUDED)
set(_UTILS_INCLUDED TRUE)

if(NOT _PREFIX_INCLUDED)
  message(FATAL_ERROR "Prefix.cmake not included before this file.")
endif()

#--- _SPLIT_CMD-----------------------------------------------------------------
#
# Sets ${_out} to a list corresponding to ${_str} split on non-escaped spaces.
# Every space (not tabs or newlines) gets replaced by a semicolon, excepted if
# the space is directly preceded by a baskslash (\) or enclosed between single
# (') or double quotes ("). The quotes must be properly paired. They can be
# nested (properly): all the spaces in the outermost pair will get
# escaped. Escapes for escape characters (\,',") are NOT taken into account.
#
function(_split_cmd _out _str)

  # Find a substring which is not a substring of _str.
  while(NOT DEFINED _found OR NOT _found EQUAL "-1")
    # Note that RANDOM default alphabet has only letters and numbers.
    string(RANDOM _uniq)
    string(FIND "${_str}" "${_uniq}" _found)
  endwhile()

  # Match every pair of double quotes, then replace in _str the spaces in each
  # of them by "A${_uniq}".
  string(REGEX MATCHALL "\"[^\"]*\"" _matches "${_str}")
  foreach(_match ${_matches})
    string(REPLACE " " "A${_uniq}" _replace "${_match}")
    string(REPLACE "${_match}" "${_replace}" _str "${_str}")
  endforeach()

  # Idem for pair of single quotes.
  string(REGEX MATCHALL "'[^']*'" _matches "${_str}")
  foreach(_match ${_matches})
    string(REPLACE " " "A${_uniq}" _replace "${_match}")
    string(REPLACE "${_match}" "${_replace}" _str "${_str}")
  endforeach()

  # Replace escaped spaces by "B${_uniq}".
  string(REPLACE "\\ " "B${_uniq}" _str "${_str}")

  # Split _str on non-escaped spaces.
  string(REPLACE " " ";" _str "${_str}")

  # Restore escaped spaces to their original values.
  string(REPLACE "A${_uniq}" " "   _str "${_str}")
  string(REPLACE "B${_uniq}" "\\ " _str "${_str}")

  set("${_out}" "${_str}" PARENT_SCOPE)
endfunction()

#--- _OBJECT_PATH --------------------------------------------------------------
#
# Sets ${_out} to the path of the object file corresponding to the source file
# ${_file} of target ${_target}. Works only for Makefiles generator.
#
function(_object_path _out _target _file)
  if(MAKEFILE_GENERATOR)
    get_filename_component(_abspath "${_file}" ABSOLUTE)
    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" _relpath "${_abspath}")
    set(_objpath "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${_target}.dir")
    set(_objpath "${_objpath}/${_relpath}${CMAKE_CXX_OUTPUT_EXTENSION}")
    set("${_out}" "${_objpath}" PARENT_SCOPE)
  else()
    message(FATAL_ERROR
      "Function object_path does not support non-makefiles generators.")
  endif()
endfunction()

#--- _RELPATH ------------------------------------------------------------------
#
# _relpath(<_out> <_file> (SOURCE | BIN | <_directory>))
#
# Sets ${_out} to the relative path of the file ${_file} w.r.t. the specified
# directory. SOURCE specifies the current source directory,
# (CMAKE_CURRENT_SOURCE_DIR), BIN the current binary directory
# (CMAKE_CURRENT_BINARY_DIR).
#
function(_relpath _out _file)
  if("${ARGN}" STREQUAL "SOURCE")
    set(_curdir "${CMAKE_CURRENT_SOURCE_DIR}")
  elseif("${ARGN}" STREQUAL "BIN")
    set(_curdir "${CMAKE_CURRENT_BINARY_DIR}")
  else()
    set(_curdir "${ARGN}")
  endif()
  get_filename_component(_abspath "${_file}" ABSOLUTE)
  string(REPLACE "${_curdir}/" "" _relpath "${_abspath}")
  set("${_out}" "${_relpath}" PARENT_SCOPE)
endfunction()

#--- _REMOVE_EXT ---------------------------------------------------------------
#
# Sets ${_out} to ${_file} without its file extension(s). This means "a.b.c.d"
# becomes "a".
#
function(_remove_ext _out _file)
  get_filename_component(_path    "${_file}" PATH)
  get_filename_component(_name_we "${_file}" NAME_WE)
  set("${_out}" "${_path}/${_name_we}" PARENT_SCOPE)
endfunction()

#--- _CHANGE_EXT ---------------------------------------------------------------
#
# Sets ${_out} to ${_file} with its file extension(s) replaced by the file
# extension ${_ext}. If ${_file} has no extension, the new file extension still
# gets appended. ${_ext} should not include a leading dot, but can contain dots
# if you want to add multiple file extensions.
#
function(_change_ext _out _file _ext)
  _remove_ext(_noext "${_file}")
  set("${_out}" "${_noext}.${_ext}" PARENT_SCOPE)
endfunction()

#--- _INSTALL_PDB_FILE ---------------------------------------------------------
#
# On Windows, add instructions to install the .pdb files related to the
# ${_target} to the ${_destination} directory.
#
function(_install_pdb_file _target _destination)
  if(MSVC)
    set(_pdb "${BUILD_BINDIR_CMAKE}/${_target}.pdb")
    install(FILES "${_pdb}" DESTINATION "${_destination}" CONFIGURATIONS Debug)
  endif()
endfunction()

endif(NOT _UTILS_INCLUDED)