message("")

message("MaNGOS-Core revision  : ${GIT_HASHSTRING}")
message("Install server to     : ${CMAKE_INSTALL_PREFIX}")

if(DEBUG)
  message("Build in debug-mode   : Yes")
else()
  message("Build in debug-mode   : No  (default)")

endif()
if(PCH)
  message("Use PCH               : Yes")
else()
  message("Use PCH               : No")
endif()

message("")
