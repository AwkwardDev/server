# Try to find precompiled headers support for GCC 3.4 and 4.x (and MSVC).
#
### Input Variables
# NOPCH, an option that if true indicates we don't want to use PCH
#
### Defined Variables
# PCH, boolean variable that says whether we use precompiled header or not
#
### Defined Macros
# ADD_PRECOMPILED_HEADER            _targetName _input              _dowarn
# ADD_PRECOMPILED_HEADER_TO_TARGET  _targetName _input _pch_output  _dowarn
# ADD_NATIVE_PRECOMPILED_HEADER     _targetName _input              _dowarn
# GET_NATIVE_PRECOMPILED_HEADER     _targetName _input
# http://gcc.gnu.org/onlinedocs/gcc/Precompiled-Headers.html

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

# TODO add way to specify additional compile flags on the header
# TODO explicit assumptions on properties/variables being lists/strings
    # current are wrong, vars & props for *FLAGS* (not inc/defs) are never lists
# TODO quoting input header & output ?
# TODO check syntax
# TODO
    # for use with distcc and gcc >4.0.1 if preprocessed files are accessible
    # on all remote machines set
    # PCH_ADDITIONAL_COMPILER_FLAGS to -fpch-preprocess
    # if you want warnings for invalid header files (which is very inconvenient
    # if you have different versions of the headers for different build types
    # http://gcc.gnu.org/onlinedocs/gcc/Preprocessor-Options.html
# TODO documentation
# TODO overwriting source flags ? -> linked with autogeneration
    # how do source flags work ?
# TODO verbatim ?
# TODO auto-set include dir (to cmake_current_binary_dir)
# TODO handle relative paths

#--- _PCH_GET_COMPILE_COMMAND --------------------------------------------------

macro(_PCH_GET_COMPILE_COMMAND _out_command _target _input _output)

  set(command "${CMAKE_CXX_COMPILER}")

  # It is assumed those variables hold strings (not lists).
  # Huge pitfall: no way to escape spaces.
  string(REPLACE " " ";" flags_for_build
    "${CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE}}")
  string(REPLACE " " ";" flags_common
    "${CMAKE_CXX_FLAGS}")
  list(APPEND command  ${flags_common} ${flags_for_build})

  # Add include directories.
  get_directory_property(_dir_inc INCLUDE_DIRECTORIES)
  get_target_property(_target_inc "${_target}" INCLUDE_DIRECTORIES)
  set(_inc ${_dir_inc} ${_target_inc})
  list(REMOVE_DUPLICATES _inc)
  list(REMOVE_ITEM _inc "_dir_inc-NOTFOUND" "_target_inc-NOTFOUND")
  foreach(item ${_inc})
    # Include flags are escaped to preserve special chars (spaces, ...)
    list(APPEND command "\"${_PCH_include_prefix}${item}\"")
  endforeach()

  # Add macro definitions.
  get_directory_property(_dir_defs COMPILE_DEFINITIONS)
  get_target_property(_target_defs "${_target}" COMPILE_DEFINITIONS)
  set(_defs ${_dir_defs} ${_target_defs})
  list(REMOVE_DUPLICATES _defs)
  list(REMOVE_ITEM _defs "_dir_defs-NOTFOUND" "_target_defs-NOTFOUND")
  foreach(item ${_defs})
    # Escape quotes in macro values.
    string(REPLACE "\"" "\\\"" item "${item}")
    # Define flags are escaped to preserve special chars (spaces, ...)
    list(APPEND command "\"${_PCH_define_prefix}${item}\"")
  endforeach()

  # Add additional compile flags.
  get_target_property(_target_flags "${_target}" COMPILE_FLAGS)
  list(REMOVE_ITEM _target_flags "_target_flags-NOTFOUND")
  foreach(item ${_target_flags})
    # Define flags are escaped to preserve special chars (spaces, ...)
    list(APPEND command "${item}")
  endforeach()

  # PCH-related flags.
  if(CMAKE_COMPILER_IS_GNUCXX)
    list(APPEND command -x c++-header -o "${_output}" "${_input}")
  elseif(MSVC)
    # TODO move this code
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/pch_dummy.cpp"
      "#include <${_input}>")
    file(TO_NATIVE_PATH "${_input}"  _n_input)
    file(TO_NATIVE_PATH "${_output}" _n_output)
    list(APPEND command /c /Fp"${_n_output}" /Yc"${_n_input}" pch_dummy.cpp)
  endif()

  set(${_out_command} "${command}")

endmacro()

#--- ADD_PRECOMPILED_HEADER ----------------------------------------------------

macro(ADD_PRECOMPILED_HEADER _target _header)
if(PCH)

  if(NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR
      "This is the ADD_PRECOMPILED_HEADER macro. "
      "You must set CMAKE_BUILD_TYPE!")
  endif()

  # The precompiled header to generate.
  set(_output
    "${CMAKE_CURRENT_BINARY_DIR}/${_target}_${CMAKE_BUILD_TYPE}.gch")

  get_filename_component(_header_name "${_header}" NAME)

  # A local copy of the header.
  set(_header_copy "${CMAKE_CURRENT_BINARY_DIR}/${_header_name}")

  # Make a local copy of the header.
  add_custom_command(
    OUTPUT  "${_header_copy}"
    COMMAND "${CMAKE_COMMAND}" -E copy "${_header}" "${_header_copy}"
    DEPENDS "${_header}")

  # Save the target current compile flags.
  get_target_property(_target_flags "${_target}" COMPILE_FLAGS)
  list(REMOVE_ITEM _target_flags "_target_flags-NOTFOUND")

  if(CMAKE_COMPILER_IS_GNUCXX)
    # Get the compile command.
    _PCH_GET_COMPILE_COMMAND(_command "${_target}" "${_header}" "${_output}")

    # Make the target depend on the precompiled header.
    add_custom_command(
      OUTPUT  "${_output}"
      COMMAND ${_command}
      DEPENDS "${_header_copy}"
  #    VERBATIM
  )
    add_custom_target("pch_${_target}" DEPENDS "${_output}")
    add_dependencies("${_target}" "pch_${_target}")

    # Flags to add to the target.
    set(pchflags "-include ${_header_copy}")

    # If there is a third argument with value NOWARN, don't warn if precompiled
    # headers end up not being used.
    if("${ARGN}" STREQUAL "NOWARN")
      list(APPEND pchflags "-Winvalid-cph")
    endif()

  elseif(MSVC)
    get_filename_component(_header_name_noext "${_header}" NAME_WE)
    get_filename_component(_header_path "${_header}" PATH)
    message("${_output}")
    set_source_files_properties("${_header_path}/${_header_name_noext}.cpp"
       PROPERTIES COMPILE_FLAGS
       "${_target_flags} /Fp${_output} /Yc${_header}")
    set(pchflags "/Fp${_output} /Yu${_header} /FI${_header}")
  endif()

  # Add the precompile flags to the target.
  set_target_properties("${_target}" PROPERTIES COMPILE_FLAGS
    "${_target_flags} ${pchflags}")

endif(PCH)
endmacro()