cmake_minimum_required(VERSION 3.4)

#set(CMAKE_VERBOSE_MAKEFILE 1)

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

project(cuda_ci_tests)

enable_language(C)
enable_language(CXX)

set(ENABLE_CUDA "TRUE" CACHE BOOL "Enable CUDA build")

if(${CMAKE_VERSION} VERSION_LESS "3.8.0")
  set(ENABLE_CUDA "FALSE" CACHE BOOL "Enable CUDA build" FORCE)
  message(WARNING "To build with CUDA support you need CMake 3.8.0+")
else()
  include(CheckLanguage)
  check_language(CUDA)
  if(CMAKE_CUDA_COMPILER)
    enable_language(CUDA)
  else()
    set(ENABLE_CUDA "FALSE" CACHE BOOL "Enable CUDA build" FORCE)
  endif()
endif()

message(STATUS "CMAKE_CUDA_COMPILER: ${CMAKE_CUDA_COMPILER}")
message(STATUS "ENV{CUDACXX}: $ENV{CUDACXX}")
