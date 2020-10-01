
include(GNUInstallDirs)

set (CMAKE_CXX_STANDARD 14)

set (COMMS_TGT "comms_tgt")
if ("${COMMS_INSTALL_DIR}" STREQUAL "")
    execute_process (
        COMMAND ${CMAKE_COMMAND} -E make_directory "${EXTERNALS_DIR}"
    ) 

    set (cc_src_dir ${EXTERNALS_DIR}/comms_champion)
    set (cc_bin_dir ${PROJECT_BINARY_DIR}/comms_champion)
    set (COMMS_INSTALL_DIR ${cc_bin_dir}/install)

    include (${PROJECT_SOURCE_DIR}/cmake/CC_Prefetch.cmake)
    cc_prefetch(SRC_DIR ${cc_src_dir} TAG ${COMMS_TAG})
    include (${cc_src_dir}/cmake/CC_External.cmake)
    cc_build_during_config(
        SRC_DIR ${cc_src_dir}
        BUILD_DIR ${cc_bin_dir}
        TAG ${COMMS_TAG}
        CMAKE_ARGS
            -DCC_COMMS_LIB_ONLY=ON -DCC_NO_UNIT_TESTS=ON
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
            -DCMAKE_INSTALL_PREFIX=${COMMS_INSTALL_DIR}        
    )
    
endif ()

list (APPEND CMAKE_PREFIX_PATH "${COMMS_INSTALL_DIR}")

find_package(LibComms NO_MODULE)

if (NOT TARGET cc::comms)
    message (Warning "Cannot compile example application due to missing COMMS libraries")
    return ()
endif ()

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

set (cc_compile_file "${COMMS_INSTALL_DIR}/lib/LibComms/cmake/CC_Compile.cmake")
if (EXISTS ${cc_compile_file})
    include (${cc_compile_file})

    set (warn_as_err_opt)
    if (NOT UBLOX_NO_WARN_AS_ERR)
        set (warn_as_err_opt WARN_AS_ERR)
    endif()

    set (ccache_opt)
    if (UBLOX_USE_CCACHE)
        set (ccache_opt USE_CCACHE)
    endif()

    cc_compile(${warn_as_err_opt} ${ccache_opt})
endif ()

add_subdirectory (simple_pos)
