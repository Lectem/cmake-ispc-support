# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

if(UNIX)
  set(CMAKE_ISPC_OUTPUT_EXTENSION .o)
else()
  set(CMAKE_ISPC_OUTPUT_EXTENSION .obj)
endif()

include(CMakeLanguageInformation)

# This file sets the basic flags for the ISPC language in CMake.
# It also loads the available platform file for the system-compiler
# if it exists.

set(_INCLUDED_FILE 0)

# Load compiler-specific information.
if(CMAKE_ISPC_COMPILER_ID)
  include(Compiler/${CMAKE_ISPC_COMPILER_ID}-ISPC OPTIONAL)
endif()

if(CMAKE_ISPC_COMPILER_ID)
  include(Platform/${CMAKE_EFFECTIVE_SYSTEM_NAME}-${CMAKE_ISPC_COMPILER_ID}-ISPC OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)
endif()
if (NOT _INCLUDED_FILE)
  include(Platform/${CMAKE_EFFECTIVE_SYSTEM_NAME}-${CMAKE_BASE_NAME} OPTIONAL
          RESULT_VARIABLE _INCLUDED_FILE)
endif ()

# load any compiler-wrapper specific information
if (CMAKE_ISPC_COMPILER_WRAPPER)
  __cmake_include_compiler_wrapper(ISPC)
endif ()

if(NOT CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG)
  set(CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG})
endif()

if(NOT CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG_SEP)
  set(CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP})
endif()

if(NOT CMAKE_SHARED_LIBRARY_RPATH_LINK_ISPC_FLAG)
  set(CMAKE_SHARED_LIBRARY_RPATH_LINK_ISPC_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG})
endif()

if(NOT DEFINED CMAKE_EXE_EXPORTS_ISPC_FLAG)
  set(CMAKE_EXE_EXPORTS_ISPC_FLAG ${CMAKE_EXE_EXPORTS_C_FLAG})
endif()

if(NOT DEFINED CMAKE_SHARED_LIBRARY_SONAME_ISPC_FLAG)
  set(CMAKE_SHARED_LIBRARY_SONAME_ISPC_FLAG ${CMAKE_SHARED_LIBRARY_SONAME_C_FLAG})
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_ISPC_FLAG)
  set(CMAKE_EXECUTABLE_RUNTIME_ISPC_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG})
endif()

if(NOT CMAKE_EXECUTABLE_RUNTIME_ISPC_FLAG_SEP)
  set(CMAKE_EXECUTABLE_RUNTIME_ISPC_FLAG_SEP ${CMAKE_SHARED_LIBRARY_RUNTIME_ISPC_FLAG_SEP})
endif()

if(NOT CMAKE_EXECUTABLE_RPATH_LINK_ISPC_FLAG)
  set(CMAKE_EXECUTABLE_RPATH_LINK_ISPC_FLAG ${CMAKE_SHARED_LIBRARY_RPATH_LINK_ISPC_FLAG})
endif()

if(NOT DEFINED CMAKE_SHARED_LIBRARY_LINK_ISPC_WITH_RUNTIME_PATH)
  set(CMAKE_SHARED_LIBRARY_LINK_ISPC_WITH_RUNTIME_PATH ${CMAKE_SHARED_LIBRARY_LINK_C_WITH_RUNTIME_PATH})
endif()

# for most systems a module is the same as a shared library
# so unless the variable CMAKE_MODULE_EXISTS is set just
# copy the values from the LIBRARY variables
if(NOT CMAKE_MODULE_EXISTS)
  set(CMAKE_SHARED_MODULE_ISPC_FLAGS ${CMAKE_SHARED_LIBRARY_ISPC_FLAGS})
  set(CMAKE_SHARED_MODULE_CREATE_ISPC_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_ISPC_FLAGS})
endif()

if(NOT CMAKE_INCLUDE_FLAG_ISPC)
  set(CMAKE_INCLUDE_FLAG_ISPC ${CMAKE_INCLUDE_FLAG_C})
endif()

set(CMAKE_VERBOSE_MAKEFILE FALSE CACHE BOOL "If this value is on, makefiles will be generated without the .SILENT directive, and all commands will be echoed to the console during the make.  This is useful for debugging only. With Visual Studio IDE projects all commands are done without /nologo.")

cmake_initialize_per_config_variable(CMAKE_ISPC_FLAGS "Flags used by the ISPC compiler")

include(CMakeCommonLanguageInclude)

# now define the following rule variables
# CMAKE_ISPC_CREATE_SHARED_LIBRARY
# CMAKE_ISPC_CREATE_SHARED_MODULE
# CMAKE_ISPC_COMPILE_OBJECT
# CMAKE_ISPC_LINK_EXECUTABLE

# Create a static archive incrementally for large object file counts.
# If CMAKE_ISPC_CREATE_STATIC_LIBRARY is set it will override these.
if(NOT DEFINED CMAKE_ISPC_ARCHIVE_CREATE)
  set(CMAKE_ISPC_ARCHIVE_CREATE "<CMAKE_AR> qc <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()
if(NOT DEFINED CMAKE_ISPC_ARCHIVE_APPEND)
  set(CMAKE_ISPC_ARCHIVE_APPEND "<CMAKE_AR> q  <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()
if(NOT DEFINED CMAKE_ISPC_ARCHIVE_FINISH)
  set(CMAKE_ISPC_ARCHIVE_FINISH "<CMAKE_RANLIB> <TARGET>")
endif()

# compile a ISPC file into an object file
if(NOT CMAKE_ISPC_COMPILE_OBJECT)
  set(CMAKE_ISPC_COMPILE_OBJECT
    "<CMAKE_ISPC_COMPILER> <SOURCE> -o <OBJECT> <DEFINES> <INCLUDES> <FLAGS>")
endif()

# set this variable so we can avoid loading this more than once.
set(CMAKE_ISPC_INFORMATION_LOADED 1)






