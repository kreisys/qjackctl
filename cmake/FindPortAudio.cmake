# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindPortAudio
-----------

Find the PortAudio libraries

Set PortAudio_ROOT cmake or environment variable to the PortAudio install root directory
to use a specific PortAudio installation.

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target:

``PortAudio::PortAudio``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``PortAudio_INCLUDE_DIRS``
  where to find portaudio.h, etc.
``PortAudio_LIBRARIES``
  the libraries to link against to use PortAudio.
``PortAudio_FOUND``
  TRUE if found

#]=======================================================================]

find_package (PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_PortAudio portaudio-2.0)
endif()

# Look for the necessary header
find_path(PortAudio_INCLUDE_DIR
	NAMES portaudio.h
	HINTS
		${PC_PortAudio_INCLUDE_DIRS}
)
mark_as_advanced(PortAudio_INCLUDE_DIR)

# Look for the necessary library
find_library(PortAudio_LIBRARY
	NAMES portaudio ${PC_PortAudio_LIBRARIES} libportaudio.dll.a
	NAMES_PER_DIR
	HINTS
		${PC_PortAudio_LIBRARY_DIRS}
)
mark_as_advanced(PortAudio_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PortAudio
	REQUIRED_VARS PortAudio_INCLUDE_DIR PortAudio_LIBRARY)

# Create the imported target
if(PortAudio_FOUND)
	set(PortAudio_INCLUDE_DIRS ${PortAudio_INCLUDE_DIR})
	set(PortAudio_LIBRARIES ${PortAudio_LIBRARY})
	if(NOT TARGET PortAudio::PortAudio)
		add_library(PortAudio::PortAudio UNKNOWN IMPORTED)
		set_target_properties(PortAudio::PortAudio PROPERTIES IMPORTED_LOCATION "${PortAudio_LIBRARY}")
		target_include_directories(PortAudio::PortAudio INTERFACE "${PortAudio_INCLUDE_DIR}")
		if(PKG_CONFIG_FOUND)
			target_compile_options(PortAudio::PortAudio INTERFACE ${PC_PortAudio_CFLAGS_OTHER})
			target_link_options(PortAudio::PortAudio INTERFACE ${PC_PortAudio_LDFLAGS_OTHER})
		elseif(WIN32)
			target_link_libraries(PortAudio::PortAudio INTERFACE dsound setupapi winmm ole32 uuid)
		endif()
	endif()
endif()
