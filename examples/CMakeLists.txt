
include(GNUInstallDirs)

set (CMAKE_CXX_STANDARD 14)

list (APPEND CMAKE_PREFIX_PATH "${COMMS_INSTALL_DIR}")

find_package(LibComms NO_MODULE REQUIRED)

find_package(Boost)

if (NOT Boost_FOUND)
    message (Warning "Cannot compile example applications due to missing boost libraries")
    return ()
endif()

set (extra_boost_components)
if (WIN32)
    # For some reason windows build requires extra boost components
    set (extra_boost_components date_time regex)
endif ()

find_package(Boost REQUIRED
    COMPONENTS program_options system ${extra_boost_components})

find_package(Threads REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/common/include)

set (cc_compile_file "${LibComms_DIR}/CC_Compile.cmake")
include (${cc_compile_file})

set (extra_opts)
if (UBLOX_WARN_AS_ERR)
    list (APPEND extra_opts WARN_AS_ERR)
endif()

if (UBLOX_USE_CCACHE)
    list (APPEND extra_opts USE_CCACHE)

    if (NOT "${UBLOX_CCACHE_EXECUTABLE}" STREQUAL "")
        list (APPEND extra_opts CCACHE_EXECTUABLE "${UBLOX_CCACHE_EXECUTABLE}")
    endif ()    
endif()

cc_compile(${extra_opts})
cc_msvc_force_warn_opt("/W4")

add_subdirectory (simple_pos)
