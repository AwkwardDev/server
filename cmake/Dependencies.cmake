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

  set(_DEP_LINK_DIR "${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_${_CONFIG_NATIVE}")

  # MySQL
  set(MYSQL_INCLUDE_DIR     "${CMAKE_SOURCE_DIR}/dep/include/mysql")
  set(MYSQL_LIBRARY         "${_DEP_LINK_DIR}/libmySQL.lib")

  # OpenSSL
  set(OPENSSL_INCLUDE_DIR   "${CMAKE_SOURCE_DIR}/dep/include/openssl")
  set(OPENSSL_LIBRARY       "${_DEP_LINK_DIR}/libeay32.lib")

  # A target that ensure a copy of the dll files into the build tree.
  set(_MYSQL_BT   "${BUILD_BINDIR_NATIVE}/libmySQL.dll")
  set(_OPENSSL_BT "${BUILD_BINDIR_NATIVE}/libeay32.dll")
  _change_ext(_MYSQL_DLL   "${MYSQL_LIBRARY}"   dll)
  _change_ext(_OPENSSL_DLL "${OPENSSL_LIBRARY}" dll)
  add_custom_command(
    OUTPUT  "${_MYSQL_BT}" "${_OPENSSL_BT}"
    COMMAND "${CMAKE_COMMAND}" -E copy "${_MYSQL_DLL}" "${_MYSQL_BT}"
    COMMAND "${CMAKE_COMMAND}" -E copy "${_OPENSSL_DLL}" "${_OPENSSL_BT}"
    DEPENDS "${_MYSQL_DLL}" "${_OPENSSL_DLL}"
    VERBATIM)
  add_custom_target(mysql_openssl ALL DEPENDS "${_MYSQL_BT}" "${_OPENSSL_BT}")

  # Install instruction for MySQL and OpenSSL Libraries.
  install(FILES "${_MYSQL_DLL}" "${_OPENSSL_DLL}" DESTINATION "${BIN_DIR}")

elseif(UNIX)

  find_package(MySQL    REQUIRED)
  find_package(OpenSSL  REQUIRED)
  find_package(ZLIB     REQUIRED)

endif()

endif(NOT _DEPENDENCIES_INCLUDED)