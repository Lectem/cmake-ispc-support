# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)



if(NOT CMAKE_ISPC_COMPILER)
    set(CMAKE_ISPC_COMPILER_INIT NOTFOUND)

    # prefer the environment variable ISPCCXX
    if(NOT $ENV{ISPC} STREQUAL "")
        get_filename_component(CMAKE_ISPC_COMPILER_INIT $ENV{ISPC} PROGRAM PROGRAM_ARGS CMAKE_ISPC_FLAGS_ENV_INIT)
        if(CMAKE_ISPC_FLAGS_ENV_INIT)
        set(CMAKE_ISPC_COMPILER_ARG1 "${CMAKE_ISPC_FLAGS_ENV_INIT}" CACHE STRING "First argument to ISPC compiler")
        endif()
        if(NOT EXISTS ${CMAKE_ISPC_COMPILER_INIT})
        message(FATAL_ERROR "Could not find compiler set in environment variable ISPC:\n$ENV{ISPC}.\n${CMAKE_ISPC_COMPILER_INIT}")
        endif()
    endif()

    # finally list compilers to try
    if(NOT CMAKE_ISPC_COMPILER_INIT)
    set(CMAKE_ISPC_COMPILER_LIST ispc)
    endif()

    _cmake_find_compiler(ISPC)
else()
    _cmake_find_compiler_path(ISPC)
endif()

mark_as_advanced(CMAKE_ISPC_COMPILER)

#[[
if(NOT CMAKE_ISPC_COMPILER_ID_RUN)
  set(CMAKE_ISPC_COMPILER_ID_RUN 1)

  # Try to identify the compiler.
  set(CMAKE_ISPC_COMPILER_ID)
  set(CMAKE_ISPC_PLATFORM_ID)



  file(READ ${CMAKE_ROOT}/Modules/CMakePlatformId.h.in
    CMAKE_ISPC_COMPILER_ID_PLATFORM_CONTENT)

  list(APPEND CMAKE_ISPC_COMPILER_ID_MATCH_VENDORS INTEL)
  set(CMAKE_ISPC_COMPILER_ID_VENDOR_FLAGS_INTEL "--version")
  set(CMAKE_ISPC_COMPILER_ID_MATCH_VENDOR_REGEX_INTEL "Intel\(r\) SPMD Program Compiler")
  
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  CMAKE_DETERMINE_COMPILER_ID(ISPC ISPCFLAGS CMakeISPCCompilerId.ispc)
endif()
#]]


set(_CMAKE_PROCESSING_LANGUAGE "ISPC")
include(CMakeFindBinUtils)
unset(_CMAKE_PROCESSING_LANGUAGE)



# configure all variables set in this file
configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeISPCCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeISPCCompiler.cmake
  @ONLY
  )


set(CMAKE_ISPC_COMPILER_ENV_VAR "ISPC")