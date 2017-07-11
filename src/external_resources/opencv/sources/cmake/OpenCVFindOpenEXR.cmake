# The script is taken from http://code.google.com/p/nvidia-texture-tools/

#
# Try to find OpenEXR's libraries, and include path.
# Once done this will define:
#
# OPENEXR_FOUND = OpenEXR found.
# OPENEXR_INCLUDE_PATHS = OpenEXR include directories.
# OPENEXR_LIBRARIES = libraries that are needed to use OpenEXR.
#

SET(OPENEXR_LIBRARIES "")
SET(OPENEXR_LIBSEARCH_SUFFIXES "")
file(TO_CMAKE_PATH "$ENV{ProgramFiles}" ProgramFiles_ENV_PATH)

if(WIN32)
    SET(OPENEXR_ROOT "C:/Deploy" CACHE STRING "Path to the OpenEXR \"Deploy\" folder")
    if(CMAKE_CL_64)
        SET(OPENEXR_LIBSEARCH_SUFFIXES x64/Release x64 x64/Debug)
    elseif(MSVC)
        SET(OPENEXR_LIBSEARCH_SUFFIXES Win32/Release Win32 Win32/Debug)
    endif()
else()
    set(OPENEXR_ROOT "")
endif()

SET(LIBRARY_PATHS
    /usr/lib
    /usr/local/lib
    /sw/lib
    /opt/local/lib
    "${ProgramFiles_ENV_PATH}/OpenEXR/lib/static"
    "${OPENEXR_ROOT}/lib")

FIND_PATH(OPENEXR_INCLUDE_PATH ImfRgbaFile.h
    PATH_SUFFIXES OpenEXR
    PATHS
    /usr/include
    /usr/local/include
    /sw/include
    /opt/local/include
    "${ProgramFiles_ENV_PATH}/OpenEXR/include"
    "${OPENEXR_ROOT}/include")

FIND_LIBRARY(OPENEXR_HALF_LIBRARY
    NAMES Half
    PATH_SUFFIXES ${OPENEXR_LIBSEARCH_SUFFIXES}
    PATHS ${LIBRARY_PATHS})

FIND_LIBRARY(OPENEXR_IEX_LIBRARY
    NAMES Iex
    PATH_SUFFIXES ${OPENEXR_LIBSEARCH_SUFFIXES}
    PATHS ${LIBRARY_PATHS})

FIND_LIBRARY(OPENEXR_IMATH_LIBRARY
    NAMES Imath
    PATH_SUFFIXES ${OPENEXR_LIBSEARCH_SUFFIXES}
    PATHS ${LIBRARY_PATHS})

FIND_LIBRARY(OPENEXR_ILMIMF_LIBRARY
    NAMES IlmImf
    PATH_SUFFIXES ${OPENEXR_LIBSEARCH_SUFFIXES}
    PATHS ${LIBRARY_PATHS})

FIND_LIBRARY(OPENEXR_ILMTHREAD_LIBRARY
    NAMES IlmThread
    PATH_SUFFIXES ${OPENEXR_LIBSEARCH_SUFFIXES}
    PATHS ${LIBRARY_PATHS})

IF (OPENEXR_INCLUDE_PATH AND OPENEXR_IMATH_LIBRARY AND OPENEXR_ILMIMF_LIBRARY AND OPENEXR_IEX_LIBRARY AND OPENEXR_HALF_LIBRARY)
    SET(OPENEXR_FOUND TRUE)
    SET(OPENEXR_INCLUDE_PATHS ${OPENEXR_INCLUDE_PATH} CACHE PATH "The include paths needed to use OpenEXR")
    SET(OPENEXR_LIBRARIES ${OPENEXR_IMATH_LIBRARY} ${OPENEXR_ILMIMF_LIBRARY} ${OPENEXR_IEX_LIBRARY} ${OPENEXR_HALF_LIBRARY} ${OPENEXR_ILMTHREAD_LIBRARY} CACHE STRING "The libraries needed to use OpenEXR" FORCE)
ENDIF ()

IF(OPENEXR_FOUND)
  IF(NOT OPENEXR_FIND_QUIETLY)
    MESSAGE(STATUS "Found OpenEXR: ${OPENEXR_ILMIMF_LIBRARY}")
  ENDIF()
  if(PKG_CONFIG_FOUND AND NOT OPENEXR_VERSION)
    get_filename_component(OPENEXR_LIB_PATH "${OPENEXR_ILMIMF_LIBRARY}" PATH)
    if(EXISTS "${OPENEXR_LIB_PATH}/pkgconfig/OpenEXR.pc")
      execute_process(COMMAND ${PKG_CONFIG_EXECUTABLE} --modversion "${OPENEXR_LIB_PATH}/pkgconfig/OpenEXR.pc"
                      RESULT_VARIABLE PKG_CONFIG_PROCESS
                      OUTPUT_VARIABLE OPENEXR_VERSION
                      OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET)
      if(NOT PKG_CONFIG_PROCESS EQUAL 0)
        SET(OPENEXR_VERSION "Unknown")
      endif()
    endif()
  endif()
  if(NOT OPENEXR_VERSION)
    SET(OPENEXR_VERSION "Unknown")
  endif()
ELSE()
  IF(OPENEXR_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "Could not find OpenEXR library")
  ENDIF()
ENDIF()

MARK_AS_ADVANCED(
    OPENEXR_INCLUDE_PATHS
    OPENEXR_LIBRARIES
    OPENEXR_ILMIMF_LIBRARY
    OPENEXR_IMATH_LIBRARY
    OPENEXR_IEX_LIBRARY
    OPENEXR_HALF_LIBRARY
    OPENEXR_ILMTHREAD_LIBRARY)
