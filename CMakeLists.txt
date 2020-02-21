cmake_minimum_required(VERSION 3.14)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake/)

project(helloworld C CXX ISPC)


add_library(libispc a.cpp b.cpp test.ispc)

add_executable(helloispc test.ispc)

