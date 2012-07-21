# Defines the the install prefix, and configures how the binaries will find the
# dynamically loaded libraries.
#
### Input Variables
# PREFIX, optionally defined by the user
#   Gived the desired install directory path (absolute or relative to root
#   source directory).
#
### Defined Variables
# BIN_DIR, the absolute path to the directory containing the executables
#   and libraries
# CONF_DIR, the absolute path to the directory containing the configuration
#   files
#
### Modified CMake Variables
# CMAKE_INSTALL_PREFIX, the absolute path to the install directory
# CMAKE_INSTALL_NAME_DIR (mac)
# CMAKE_INSTALL_RPATH (other unix)
# CMAKE_BUILD_WITH_INSTALL_RPATH (unix)

if(PREFIX)
  # Install directory is PREFIX converted to absolute path, else the default
  # install directory will be used.
  # Note: path are relative to the root source folder.
  get_filename_component(CMAKE_INSTALL_PREFIX ${PREFIX} ABSOLUTE)
else()
    # Add the variable to the cache so that users may override it.
    set(PREFIX ${CMAKE_INSTALL_PREFIX} CACHE PATH "Install prefix.")
endif()

set(BIN_DIR  ${CMAKE_INSTALL_PREFIX}/bin)
set(CONF_DIR ${CMAKE_INSTALL_PREFIX}/etc)

# Put all outputs into <build_dir>/bin. Makes it easier to see what has/hasn't
# been built.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

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
    # contain "@loader_path". Since our library is always at the same place
    # relative to the executables, this is no use to us.
    set(CMAKE_INSTALL_NAME_DIR @loader_path)
  else()
    # On Unices, the libraries ares searched in the RPATH.
    # info : http://www.cmake.org/Wiki/CMake_RPATH_handling
    set(CMAKE_INSTALL_RPATH $ORIGIN)
  endif()
  # Set the RPATH directly. This allows for "manual installation by copying
  # files" (which is auseless) and disallows running the code form the build
  # tree (an even worse idea because the path to config files is absolute and
  # some libraries cannot be found anyway).
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
endif()