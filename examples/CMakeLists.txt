if ((CMAKE_COMPILER_IS_GNUCC) OR ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang"))
    set (extra_flags_list
        "-Wall" "-Wextra" "-Wcast-align" "-Wcast-qual" "-Wctor-dtor-privacy"
        "-Wmissing-include-dirs"
        "-Woverloaded-virtual" "-Wredundant-decls" "-Wshadow" "-Wundef" "-Wunused"
        "-Wno-unknown-pragmas" "-fdiagnostics-show-option"
    )

    if (CMAKE_COMPILER_IS_GNUCC)
        list (APPEND extra_flags_list
            "-Wnoexcept" "-Wlogical-op" "-Wstrict-null-sentinel"
        )

        if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.8")
            list (APPEND extra_flags_list
                "-Wno-pragmas" "-Wno-type-limits"
            )
        endif()

    endif ()

    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        list (APPEND extra_flags_list "-Wno-dangling-field -Wno-unused-command-line-argument")
    endif ()
    
    if (NOT UBLOX_NO_WARN_AS_ERR)
        list (APPEND extra_flags_list "-Werror")
    endif ()
    
    string(REPLACE ";" " " extra_flags "${extra_flags_list}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${extra_flags}")
    
elseif (MSVC)

    add_definitions("/wd4503" "/wd4309" "/wd4267" "-D_SCL_SECURE_NO_WARNINGS")

    if (NOT UBLOX_NO_WARN_AS_ERR)
        add_definitions("/WX")
    endif ()
    
endif ()

include(GNUInstallDirs)

set (CMAKE_CXX_STANDARD 14)

set (COMMS_TGT "comms_tgt")
if ("${COMMS_INSTALL_DIR}" STREQUAL "")
    include(ExternalProject)
    if ("${COMMS_TAG}" STREQUAL "")
        set(COMMS_TAG "develop")
    endif ()

    set (cc_main_dir "${CMAKE_BINARY_DIR}/comms_champion")
    set (cc_src_dir "${cc_main_dir}/src")
    set (cc_bin_dir "${cc_main_dir}/build")
    set (cc_install_dir "${cc_bin_dir}/install")


    ExternalProject_Add(
        "${COMMS_TGT}"
        PREFIX "${cc_bin_dir}"
        STAMP_DIR "${cc_bin_dir}"
        GIT_REPOSITORY "https://github.com/arobenko/comms_champion.git"
        GIT_TAG "${COMMS_TAG}"
        SOURCE_DIR "${cc_src_dir}"
        CMAKE_ARGS
            -DCC_COMMS_LIB_ONLY=ON -DCC_NO_UNIT_TESTS=ON
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
            -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        BINARY_DIR "${cc_bin_dir}"
    )

    include_directories(${cc_install_dir}/include)
else ()
    list (APPEND CMAKE_PREFIX_PATH "${COMMS_INSTALL_DIR}")

    find_package(CommsChampion NO_MODULE)

    if (NOT CC_COMMS_FOUND)
        message (Warning "Cannot compile example application due to missing COMMS libraries")
        return ()
    endif ()

    include_directories(${CC_INCLUDE_DIRS})
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

add_subdirectory (simple_pos)
