# Adds precompiled headers support for GCC 3.4.x GCC 4.x.x and MSVC.
#
### Input Variables
# NOPCH, an option that if true indicates we don't want to use PCH
#
### Output Variables
# PCH, boolean variable that says whether we use precompiled header or not.
#
### Defined Macros
#
# add_precompiled_header _target _header
#
# Precompiles the header ${_header} for target ${_target}. If you are using
# MSVC, you need to have a file called the same as the header (but with .cpp
# extension) in the sources of the target. This file should just include the
# header file. Nothing else needs to be done. Important: the header must passed
# with the same path than the one with wich the cpp file was added to the
# target. (So it's probably a relative path you want.)
#
# If for some reason there is a mismatch between the command used to compile
# the header and the command used to compile the objects files with GCC, you can
# use the variables _PCH_ADDITIONAL_FLAGS and _PCH_EXCLUDE_FLAGS to add/remove
# flags from the header compile command.
#
### Info
#
# Please respect the types of CMake variables and properties (this is hard
# because they are mostly undocumented). In particular:
#
# CMAKE_CXX_FLAGS* hold flags as a string (i.e. with spaces between flags).
# The INCLUDE_DIRECTORIES and COMPILE_DEFINITIONS properties are lists. The
# The COMPILE_FLAGS property hold flags as a string.
#
# This module is fully generic and relies only on the Utils.cmake file.
#
# Learn more about precompiled headers:
# http://gcc.gnu.org/onlinedocs/gcc/Precompiled-Headers.html
# http://msdn.microsoft.com/en-us/library/szfdksca%28v=vs.71%29.aspx

if(NOT _PCH_INCLUDED)
set(_PCH_INCLUDED TRUE)

if(NOT _UTILS_INCLUDED)
  message(FATAL_ERROR "Utils.cmake not included before this file.")
endif()

if(CMAKE_COMPILER_IS_GNUCXX)
  exec_program(${CMAKE_CXX_COMPILER}
    ARGS ${CMAKE_CXX_COMPILER_ARG1} -dumpversion
    OUTPUT_VARIABLE gcc_compiler_version)
  if(gcc_compiler_version MATCHES "4\\.[0-9]\\.[0-9]")
    set(PCHSupport_FOUND TRUE)
  elseif(gcc_compiler_version MATCHES "3\\.4\\.[0-9]")
    set(PCHSupport_FOUND TRUE)
  endif()
  set(_PCH_define_prefix  "-D")
  set(_PCH_include_prefix "-I")
elseif(MSVC)
  set(PCHSupport_FOUND TRUE)
  set(_PCH_define_prefix  "/D")
  set(_PCH_include_prefix "/I")
else()
  set(PCHSupport_FOUND FALSE)
endif()

if(PCHSupport_FOUND AND NOT NOPCH)
  set(PCH YES)
else()
  set(PCH NO)
endif()

#--- _PCH_GET_COMPILE_COMMAND --------------------------------------------------

function(_pch_get_compile_command _out _target _input _output)

  set(command "${CMAKE_CXX_COMPILER}")

  # Add the default flags.
  string(TOUPPER "${CMAKE_BUILD_TYPE}" CAPS_BUILD_TYPE)
  _split_cmd(_build_flags  "${CMAKE_CXX_FLAGS_${CAPS_BUILD_TYPE}}")
  _split_cmd(_common_flags "${CMAKE_CXX_FLAGS}")
  list(APPEND command ${_build_flags} ${_common_flags})

  # Add include directories.
  get_directory_property(_dir_inc INCLUDE_DIRECTORIES)
  get_target_property(_target_inc "${_target}" INCLUDE_DIRECTORIES)
  set(_inc ${_dir_inc} ${_target_inc})
  list(REMOVE_DUPLICATES _inc)
  list(REMOVE_ITEM _inc "_dir_inc-NOTFOUND" "_target_inc-NOTFOUND")
  foreach(item ${_inc})
    list(APPEND command "${_PCH_include_prefix}${item}")
  endforeach()

  # Add macro definitions.
  get_directory_property(_dir_defs              COMPILE_DEFINITIONS)
  get_target_property   (_tar_defs "${_target}" COMPILE_DEFINITIONS)

  get_directory_property(_dir_defs_conf
    "COMPILE_DEFINITIONS_${CAPS_BUILD_TYPE}")
  get_target_property   (_tar_defs_conf "${_target}"
    "COMPILE_DEFINITIONS_${CAPS_BUILD_TYPE}")

  set(_defs ${_dir_defs} ${_tar_defs} ${_dir_defs_conf} ${_tar_defs_conf})
  list(REMOVE_DUPLICATES _defs)
  list(REMOVE_ITEM _defs
    "_dir_defs-NOTFOUND"        "_tar_defs-NOTFOUND"
    "_dir_defs_conf-NOTFOUND"   "_tar_defs_conf-NOTFOUND")

  foreach(item ${_defs})
    list(APPEND command "${_PCH_define_prefix}${item}")
  endforeach()

  # Add additional compile flags.
  get_target_property(_tar_flags "${_target}" COMPILE_FLAGS)
  list(REMOVE_ITEM _tar_flags "_tar_flags-NOTFOUND")
  foreach(item ${_tar_flags})
    list(APPEND command "${item}")
  endforeach()

  # User overrides.
  list(REMOVE_ITEM command "" ${_PCH_EXCLUDE_FLAGS})
  list(APPEND command ${_PCH_ADDITIONAL_FLAGS})

  # PCH-related flags.
  if(CMAKE_COMPILER_IS_GNUCXX)
    list(APPEND command -x c++-header -o "${_output}" "${_input}")
  elseif(MSVC)
    # TODO move this code
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/pch_dummy.cpp"
      "#include <${_input}>")
    list(APPEND command /c /Fp"${_output}" /Yc"${_input}" pch_dummy.cpp)
  endif()

  set("${_out}" "${command}" PARENT_SCOPE)

endfunction()

#--- ADD_PRECOMPILED_HEADER ----------------------------------------------------

function(add_precompiled_header _target _header)
if(PCH)
  set(_header_orig "${_header}")
  get_filename_component(_header "${_header}" ABSOLUTE)

  if(CMAKE_COMPILER_IS_GNUCXX)

    get_filename_component(_header_name "${_header}" NAME)
    set(_output "${CMAKE_CURRENT_BINARY_DIR}/${_header_name}.gch")
    _pch_get_compile_command(_command "${_target}" "${_header}" "${_output}")

    # Make the target depend on the precompiled header.
    add_custom_command(
      OUTPUT  "${_output}"
      COMMAND ${_command}
      DEPENDS "${_header}"
      VERBATIM)
    add_custom_target("pch_${_target}" DEPENDS "${_output}")
    add_dependencies("${_target}" "pch_${_target}")

    # Add the precompile flags to the target.
    # FUTURE Change to APPEND_STRING when switching to 2.9.
    get_target_property("${_target}" _cflags COMPILE_FLAGS)
    set(_cflags "${_cflags} \"-I${CMAKE_CURRENT_BINARY_DIR}\"")
    set(_cflags "${_cflags} -include ${_header_name} -Winvalid-pch")
    set_target_properties("${_target}" PROPERTIES COMPILE_FLAGS "${_cflags}")

  elseif(MSVC)

    # On MSVC, we can avoid re-building the compile command by adding a switch
    # on a source file. This works because MSVC can produe two outputs (an
    # object file + the precompiled header) for a single file, which GCC
    # cannot. We cannot opt to only build the precompiled header on GCC because
    # we cannot control the name of the output file and gcc wants it to be
    # <header>.h.gch.
    #
    # This approach is useful because it does not create additional targets,
    # which would clutter the Visual Studio solution.
    #
    # Note that wa cannot auto-generate the required .cpp file because CMake
    # does not offer a way to add sources to a target outside of the add_target
    # command.

    if(VISUAL_STUDIO)
      set(_output
        "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${_target}.pch")
    else()
      set(_output "${CMAKE_CURRENT_BINARY_DIR}/${_target}.pch")
    endif()

    set(_header_esc "\"${_header}\"")
    set(_output_esc "\"${_output}\"")
    _change_ext(_cpp_file "${_header}" cpp)

    # Add the precompiled header creation flags to the source file.
    set_property(SOURCE "${_cpp_file}"
      APPEND_STRING PROPERTY COMPILE_FLAGS
      " /Fp${_output_esc} /Yc${_header_esc}")

    # Explicitly encode the dependency between sources files (the file
    # generating the header excepted) and the precompiled header.
    get_target_property(_sources "${_target}" SOURCES)
    list(REMOVE_ITEM _sources "${_cpp_file}")
    set_source_files_properties(${_sources} PROPERTIES
      OBJECT_DEPENDS "${_output}")
    set_source_files_properties("${_cpp_file}" PROPERTIES
      OBJECT_OUTPUTS "${_output}")

    # Add the precompiled header usage flags to the target.
    set_property(TARGET "${_target}" APPEND_STRING PROPERTY COMPILE_FLAGS
      " /Fp${_output_esc} /Yu${_header_esc} /FI${_header_esc}")

  endif()
endif(PCH)
endfunction()

endif(NOT _PCH_INCLUDED)