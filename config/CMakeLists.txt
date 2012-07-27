# If configuration files are present in this directory, they will be copied over
# to the build tree, which allows to run the server from there. This is useful
# when using debuggers such as the one integrated to Visual Studio.

# You can find configuration file templates in <build_directory>/config after
# running a build. Copy them over, customize them to your liking, then remove
# the ".dist" extension.

add_custom_target(config_files ALL
  DEPENDS mangosd realmd mangosscript)

add_custom_command(TARGET config_files POST_BUILD
  COMMAND "${CMAKE_COMMAND}"
    -D _CONFIG_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
    -D _BUILD_BINDIR="${BUILD_BINDIR_NATIVE}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/CopyConfig.cmake")
