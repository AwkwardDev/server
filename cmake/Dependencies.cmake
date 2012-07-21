#---------------------------------------------------#
# DEPENDENCIES LIST                                 #
#---------------------------------------------------#
#           WINDOWS         UNIX                    #
# MySQL     pre-compiled    external                #
# OpenSSL   pre-compiled    external                #
# ZLIB      compiled        external                #
# ACE       compiled        external?               #
# TBB       compiled        external    (optional)  #
#---------------------------------------------------#

if(WIN32)

  # MySQL
  set(MYSQL_INCLUDE_DIR
    ${CMAKE_SOURCE_DIR}/dep/include/mysql)
  set(MYSQL_LIBRARY
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libmySQL.lib)
  set(MYSQL_DEBUG_LIBRARY
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libmySQL.lib)

  # OpenSSL
  set(OPENSSL_INCLUDE_DIR
    ${CMAKE_SOURCE_DIR}/dep/include/openssl)
  set(OPENSSL_LIBRARIES
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libeay32.lib)
  set(OPENSSL_DEBUG_LIBRARIES
    ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libeay32.lib)

  # ACE
  set(ACE_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/dep/acelite")
  set(ACE_LIBRARY "ace")
  set(HAVE_ACE_STACK_TRACE_H ON) # config.h.cmake

  # TBB
  if(NOT USE_STD_MALLOC)
    set(TBB_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/dep/tbbmalloc/")
    set(TBB_LIBRARY "tbbmalloc")
  endif()

elseif(UNIX)

  find_package(ACE      REQUIRED)
  find_package(MySQL    REQUIRED)
  find_package(OpenSSL  REQUIRED)
  find_package(ZLIB     REQUIRED)

  if(NOT USE_STD_MALLOC)
    find_package(TBB    REQUIRED)
  endif()

endif()

# Install instruction for MySQL and OpenSSL Libraries.
if(WIN32)
  install(
    FILES
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libeay32.dll
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_release/libmySQL.dll
    DESTINATION ${BIN_DIR}
    CONFIGURATIONS Release)
  install(
    FILES
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libeay32.dll
      ${CMAKE_SOURCE_DIR}/dep/lib/${PLATFORM}_debug/libmySQL.dll
    DESTINATION ${BIN_DIR}
    CONFIGURATIONS Debug)
endif()