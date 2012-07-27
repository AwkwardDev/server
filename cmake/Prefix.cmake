# Defines the the install prefix, and configures how the binaries will find the
# dynamically loaded libraries.
#
### Input Variables
# PREFIX, optionally defined by the user
#   Gives the desired install directory path (absolute or relative to root
#   source directory).
#
### Defined Variables
# BIN_DIR, the absolute path to the directory containing the executables
#   and libraries
# CONF_DIR, the absolute path to the directory containing the configuration
#   files
#
### Modified CMake Variables
# CMAKE_INSTALL_PREFIX, the absolute path to the install directory.
# CMAKE_INSTALL_NAME_DIR (mac)
# CMAKE_INSTALL_RPATH (other unix)
# CMAKE_BUILD_WITH_INSTALL_RPATH (unix)

if(NOT _PREFIX_INCLUDED)
set(_PREFIX_INCLUDED TRUE)

if(NOT _PLATFORM_INCLUDED)
  message(FATAL_ERROR "Platform.cmake not included before this file.")
endif()

#--- INSTALLATION PATHS --------------------------------------------------------

# The install directory is PREFIX converted to absolute path, else the default
# install directory will be used.
if(PREFIX)
  get_filename_component(CMAKE_INSTALL_PREFIX "${PREFIX}" ABSOLUTE)
else()
    # Add the variable to the cache so that users may override it.
    set(PREFIX "${CMAKE_INSTALL_PREFIX}" CACHE PATH "Install prefix.")
endif()

# Hide CMAKE_INSTALL_PREFIX from the GUI.
set(CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" CACHE INTERNAL
  "Use PREFIX instead." FORCE)

# Where to install binaries and configuration files.
set(BIN_DIR  "${CMAKE_INSTALL_PREFIX}/bin")
set(CONF_DIR "${CMAKE_INSTALL_PREFIX}/etc")

# Path to the configuration files, relative to the binary directory.
set(CONF_DIR_REL "../etc")

#--- CONFIGURATION NAME --------------------------------------------------------

if(MULTICONFIG_GENERATOR)
  # Do build config determination at build-time rather than config-time.

  # Safe to use in values that will end up in system-specific files
  # (e.g. Makefiles, Visual Studio project files), for instance in the
  # dependencies of a target.
  set(_CONFIG_NATIVE "${CMAKE_CFG_INTDIR}")

  # Safe to use in values that will end up a CMake file in the build tree,
  # for instance in a filename used in the "install" command.
  set(_CONFIG_CMAKE  "\${BUILD_TYPE}")
else()
  set(_CONFIG_NATIVE "${CMAKE_BUILD_TYPE}")
  set(_CONFIG_CMAKE  "${CMAKE_BUILD_TYPE}")
endif()

#--- OUTPUT PATH ---------------------------------------------------------------

# Put all executables and (on Windows) DLLs into <build_dir>/bin.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
# Put all shared libraries (on Unix) into <build_dir>/bin.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# The actual location of the binary files in the build tree.
# See above for the difference between "native" and "cmake".
set(BUILD_BINDIR_NATIVE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(BUILD_BINDIR_CMAKE  "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
if(MULTICONFIG_GENERATOR)
  # On multi-config generators, a configuration-specific prefix is appended to
  # the output directory.
  set(BUILD_BINDIR_NATIVE "${BUILD_BINDIR_NATIVE}/${_CONFIG_NATIVE}")
  set(BUILD_BINDIR_CMAKE  "${BUILD_BINDIR_CMAKE}/${_CONFIG_CMAKE}")
endif()

#--- SHARED LIBRARIES SEARCH PATH ----------------------------------------------

# On Windows, dynamically loaded libraries are searched in the same folder as
# the linking executable.
if(UNIX)
  if(APPLE)
    # On Mac OS X, the libraries are search in the install name directory. The
    # install name can include "@loader_path" which is the directory containing
    # the code loading the library (an executable or another library).
    #
    # Since Mac OS 10.5, RPATH (see below) is supported. However, the install
    # name still needs to be specified, and needs to include "@rpath" which will
    # be tentatively replaced by the supplied paths. The paths can in turn
    # contain "@loader_path". Since our libraries are always at the same place
    # relative to the executables, this is no use to us.
    set(CMAKE_INSTALL_NAME_DIR "@loader_path")
  else()
    # On Unices, the libraries ares searched in the RPATH.
    # info : http://www.cmake.org/Wiki/CMake_RPATH_handling
    set(CMAKE_INSTALL_RPATH "$ORIGIN")
  endif()
  # Set the RPATH at build-time rather than install time. This allows to check
  # that the relative paths works correctly when running from the build tree.
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
endif()

endif(NOT _PREFIX_INCLUDED)