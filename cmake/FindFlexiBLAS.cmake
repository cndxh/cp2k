#!-------------------------------------------------------------------------------------------------!
#!   CP2K: A general program to perform molecular dynamics simulations                             !
#!   Copyright 2000-2022 CP2K developers group <https://cp2k.org>                                  !
#!                                                                                                 !
#!   SPDX-License-Identifier: GPL-2.0-or-later                                                     !
#!-------------------------------------------------------------------------------------------------!

# Copyright (c) 2022- ETH Zurich
#
# authors : Mathieu Taillefumier

include(FindPackageHandleStandardArgs)
include(cp2k_utils)

cp2k_set_default_paths(FLEXIBLAS "FlexiBLAS")

# try first with pkg-config
find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
  pkg_check_modules(CP2K_FLEXIBLAS IMPORTED_TARGET GLOBAL flexiblas)
endif()

# manual; search
if(NOT CP2K_FLEXIBLAS_FOUND)
  cp2k_find_libraries(FLEXIBLAS "flexiblas")
endif()

# search for include directories anyway
if(NOT CP2K_FLEXIBLAS_INCLUDE_DIRS)
  cp2k_include_dirs(FFTW3 "flexiblas.h")
endif()

find_package_handle_standard_args(
  FlexiBLAS DEFAULT_MSG CP2K_FLEXIBLAS_INCLUDE_DIRS
  CP2K_FLEXIBLAS_LINK_LIBRARIES)

if(NOT CP2K_FLEXIBLAS_FOUND)
  set(CP2K_BLAS_VENDOR "FlexiBLAS")
endif()

if(CP2K_FLEXIBLAS_FOUND AND NOT TARGET CP2K_FlexiBLAS::flexiblas)
  add_library(CP2K_FlexiBLAS::flexiblas INTERFACE IMPORTED)
  add_library(CP2K_FlexiBLAS::blas ALIAS CP2K_FlexiBLAS::flexiblas)
  set_target_properties(
    CP2K_FlexiBLAS::flexiblas PROPERTIES INTERFACE_LINK_LIBRARIES
                                         "${CP2K_FLEXIBLAS_LINK_LIBRARIES}")
  if(CP2K_FLEXIBLAS_INCLUDE_DIRS)
    set_target_properties(
      CP2K_FlexiBLAS::flexiblas PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                           "${CP2K_FLEXIBLAS_INCLUDE_DIRS}")
  endif()
  set(CP2K_BLAS_VENDOR "flexiblas")
endif()

mark_as_advanced(CP2K_FLEXIBLAS_FOUND CP2K_FLEXIBLAS_INCLUDE_DIRS
                 CP2K_FLEXIBLAS_LINK_LIBRARIES CP2K_BLAS_VENDOR)
