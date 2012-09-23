# See config/README.md

add_custom_target(config_files ALL
  DEPENDS mangosd realmd mangosscript)

add_custom_command(TARGET config_files POST_BUILD
  COMMAND "${CMAKE_COMMAND}"
    -D _CONFIG_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
    -D _BUILD_BINDIR="${BUILD_BINDIR_NATIVE}"
    -P "${CMAKE_CURRENT_SOURCE_DIR}/CopyConfig.cmake")
