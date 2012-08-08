#---------------------------------------------------#
# DEPENDENCIES LIST                                 #
#---------------------------------------------------#
#           WINDOWS         UNIX                    #
# MySQL     pre-compiled    external                #
# OpenSSL   pre-compiled    external                #
# ZLIB      compiled        external                #
# ACE          compiled or external                 #
#                                                   #
# optional                                          #
# TBBMalloc    compiled or external                 #
#---------------------------------------------------#

if(NOT _DEPENDENCIES_INCLUDED)
set(_DEPENDENCIES_INCLUDED TRUE)

include(FindPackageHandleStandardArgs)
set(_FIND_HANDLE_INCLUDED TRUE)

if(NOT _PREFIX_INCLUDED)
  message(FATAL_ERROR "Prefix.cmake not included before this file.")
endif()

# ACE
if(NOT ACE_USE_EXTERNAL)
  set(ACE_INCLUDE_DIR       "${CMAKE_SOURCE_DIR}/dep/acelite")
  set(ACE_LIBRARY           "ace")
  set(HAVE_ACE_STACK_TRACE_H ON) # config.h.cmake
else()
  find_package(ACE REQUIRED)
endif()

# TBBMalloc
if(NOT USE_STD_MALLOC)
  if(NOT TBB_USE_EXTERNAL)
    set(TBBMalloc_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/dep/tbbmalloc/")
    set(TBBMalloc_LIBRARY "tbbmalloc")
  else()
    find_package(TBBMalloc REQUIRED)
  endif()
endif()

if(WIN32)

  # Where to find the precompiled dlls. The path is expressed differently at
  # build time and install time (but stays the same).
  set(_link_dir "${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_${_CONFIG_NATIVE}")
  set(_inst_dir "${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_${_CONFIG_CMAKE}")

  # MySQL
  set(MYSQL_INCLUDE_DIR     "${CMAKE_SOURCE_DIR}/dep/include/mysql")
  set(MYSQL_LIBRARY         "${_link_dir}/libmySQL.lib")
  set(_mysql_link_dll       "${_link_dir}/libmySQL.dll")
  set(_mysql_inst_dll       "${_inst_dir}/libmySQL.dll")
  set(_mysql_bt             "${BUILD_BINDIR_NATIVE}/libmySQL.dll")

  # OpenSSL
  set(OPENSSL_INCLUDE_DIR   "${CMAKE_SOURCE_DIR}/dep/include/openssl")
  set(OPENSSL_LIBRARY       "${_link_dir}/libeay32.lib")
  set(_openssl_link_dll     "${_link_dir}/libeay32.dll")
  set(_openssl_inst_dll     "${_inst_dir}/libeay32.dll")
  set(_openssl_bt           "${BUILD_BINDIR_NATIVE}/libeay32.dll")

  # A target that ensure a copy of the dll files into the build tree (bt).
  add_custom_command(
    OUTPUT  "${_mysql_bt}" "${_openssl_bt}"
    COMMAND "${CMAKE_COMMAND}" -E copy "${_mysql_link_dll}"   "${_mysql_bt}"
    COMMAND "${CMAKE_COMMAND}" -E copy "${_openssl_link_dll}" "${_openssl_bt}"
    DEPENDS "${_mysql_link_dll}" "${_openssl_link_dll}"
    VERBATIM)
  add_custom_target(mysql_openssl ALL DEPENDS "${_mysql_bt}" "${_openssl_bt}")

  # Install instruction for MySQL and OpenSSL Libraries.
  install(FILES "${_mysql_inst_dll}" "${_openssl_inst_dll}"
    DESTINATION "${BIN_DIR}")

elseif(UNIX)

  find_package(MySQL    REQUIRED)
  find_package(OpenSSL  REQUIRED)
  find_package(ZLIB     REQUIRED)

endif()

endif(NOT _DEPENDENCIES_INCLUDED)