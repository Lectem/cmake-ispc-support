# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

if(CMAKE_ISPC_COMPILER_FORCED)
  # The compiler configuration was forced by the user.
  # Assume the user has configured all compiler information.
  set(CMAKE_ISPC_COMPILER_WORKS TRUE)
  return()
endif()

include(CMakeTestCompilerCommon)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that the selected ISPC compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
if(NOT CMAKE_ISPC_COMPILER_WORKS)
    PrintTestCompilerStatus("ISPC" "${CMAKE_ISPC_COMPILER}")
    file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/main.ispc
    "export void simple(uniform float vin[], uniform float vout[], uniform int count) {"
    "   foreach(index = 0 ... count) {"
    "       float v = vin[index];"
    "       if( v < 3.)"
    "           v = v * v;"
    "       else"
    "           v = sqrt(v);"
    "       vout[index] = v;"
    "   }"
    "}"
    )
  try_compile(CMAKE_ISPC_COMPILER_WORKS ${CMAKE_BINARY_DIR} ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/main.ispc
    OUTPUT_VARIABLE __CMAKE_ISPC_COMPILER_OUTPUT
    )
  # Move result from cache to normal variable.
  set(CMAKE_ISPC_COMPILER_WORKS ${CMAKE_ISPC_COMPILER_WORKS})
  unset(CMAKE_ISPC_COMPILER_WORKS CACHE)
  set(ISPC_TEST_WAS_RUN 1)
endif()

if(NOT CMAKE_ISPC_COMPILER_WORKS)
  PrintTestCompilerStatus("ISPC" "${CMAKE_ISPC_COMPILER} -- broken")
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the ISPC compiler works failed with "
    "the following output:\n${__CMAKE_ISPC_COMPILER_OUTPUT}\n\n")
  string(REPLACE "\n" "\n  " _output "${__CMAKE_ISPC_COMPILER_OUTPUT}")
  message(FATAL_ERROR "The ISPC compiler\n  \"${CMAKE_ISPC_COMPILER}\"\n"
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n  ${_output}\n\n"
    "CMake will not be able to correctly generate this project.")
else()
  if(ISPC_TEST_WAS_RUN)
    PrintTestCompilerStatus("ISPC" "${CMAKE_ISPC_COMPILER} -- works")
    file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the ISPC compiler works passed with "
      "the following output:\n${__CMAKE_ISPC_COMPILER_OUTPUT}\n\n")
  endif()

  # Re-configure to save learned information.
  configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/CMakeISPCCompiler.cmake.in
    ${CMAKE_PLATFORM_INFO_DIR}/CMakeISPCCompiler.cmake
    @ONLY
    )
  include(${CMAKE_PLATFORM_INFO_DIR}/CMakeISPCCompiler.cmake)
endif()




