cmake_minimum_required (VERSION 3.5)
project ("cc.ublox.commsdsl")

# Additional variables to be used if needed
# ---------------------------
# OUTPUT_DIR - Path to output directory. If not provided <build_dir>/output one is used.
# COMMSDSL2COMMS - Path to "commsdsl2comms" binary.
# COMMSDSL2COMMS_EXTRA_ARGS - Extra arguments to pass to "commsdsl2comms"

set (COMMSDSL_TGT "commsdsl_tgt")
if ("${COMMSDSL2COMMS}" STREQUAL "")
        include(ExternalProject)
        set (commsdsl2comms_tag "develop")
        set (commsdsl2comms_main_dir "${CMAKE_BINARY_DIR}/commsdsl")
        set (commsdsl2comms_src_dir "${commsdsl2comms_main_dir}/src")
        set (commsdsl2comms_bin_dir "${commsdsl2comms_main_dir}/build")
        set (commsdsl2comms_install_dir "${commsdsl2comms_main_dir}/install")
        
        set (boost_static_libs_param)
        if (Boost_USE_STATIC_LIBS)
        set (boost_static_libs_param "-DBoost_USE_STATIC_LIBS=ON")
        endif()

        ExternalProject_Add(
            "${COMMSDSL_TGT}"
            PREFIX "${commsdsl2comms_bin_dir}"
            STAMP_DIR "${commsdsl2comms_bin_dir}"
            GIT_REPOSITORY "https://github.com/arobenko/commsdsl.git"
            GIT_TAG "${commsdsl2comms_tag}"
            SOURCE_DIR "${commsdsl2comms_src_dir}"
            CMAKE_ARGS
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${commsdsl2comms_install_dir}
                -DCOMMSDSL_NO_TESTS=ON -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} -DBOOST_ROOT=${BOOST_ROOT}
                ${boost_static_libs_param}
            BINARY_DIR "${commsdsl2comms_bin_dir}"
        )
        
        set (COMMSDSL2COMMS "${commsdsl2comms_install_dir}/bin/commsdsl2comms")
        
        if (UNIX)
            set (COMMSDSL2COMMS "${COMMSDSL2COMMS}.sh")
        endif ()
endif ()

set (schema_files
    dsl/main.xml
    dsl/field/common.xml
    dsl/message/NavPosecef.xml
    dsl/message/NavPosllh.xml
    dsl/message/NavStatus.xml
    dsl/message/NavDop.xml
    dsl/message/NavAtt.xml
    dsl/message/NavSol.xml
    dsl/message/NavPvt.xml
    dsl/message/NavOdo.xml
    dsl/message/NavResetodo.xml
    dsl/message/NavVelecef.xml
    dsl/message/NavVelned.xml
    dsl/message/NavHpposecef.xml
    dsl/message/NavHpposllh.xml
    dsl/message/NavTimegps.xml
    dsl/message/NavTimeutc.xml
    dsl/message/NavClock.xml
    dsl/message/NavTimeglo.xml
    dsl/message/NavTimebds.xml
    dsl/message/NavTimegal.xml
    dsl/message/NavTimels.xml
    dsl/message/NavSvinfo.xml
    dsl/message/NavDgps.xml
    dsl/message/NavSbas.xml
    dsl/message/NavOrb.xml
    dsl/message/NavSat.xml
    dsl/message/NavGeofence.xml
    dsl/message/NavSvin.xml
    dsl/message/NavRelposned.xml
    dsl/message/NavAopstatus.xml
    dsl/message/NavEoe.xml
    dsl/message/RxmRaw.xml
    dsl/message/RxmSfrb.xml
    dsl/message/RxmSfrbx.xml
    dsl/message/RxmMeasx.xml
    dsl/message/RxmRawx.xml
    dsl/message/RxmSvsi.xml
    dsl/message/RxmAlm.xml
    dsl/message/RxmEph.xml
    dsl/message/RxmRtcm.xml
    dsl/message/RxmPmreq.xml
    dsl/message/RxmRlm.xml
    dsl/message/RxmImes.xml
    dsl/message/Inf.xml
    dsl/message/Ack.xml
    dsl/message/CfgPrt.xml
    dsl/message/CfgMsg.xml
    dsl/message/CfgInf.xml
    dsl/message/CfgRst.xml
    dsl/message/CfgDat.xml
    dsl/message/CfgTp.xml
    dsl/message/CfgRate.xml
    dsl/message/CfgCfg.xml
    dsl/message/CfgFxn.xml
    dsl/message/CfgRxm.xml
    dsl/message/CfgEkf.xml
    dsl/message/CfgAnt.xml
    dsl/message/CfgSbas.xml
    dsl/message/CfgNmea.xml
    dsl/message/CfgUsb.xml
    dsl/message/CfgTmode.xml
    dsl/message/CfgOdo.xml
    dsl/message/CfgNvs.xml
    dsl/message/CfgNavx5.xml
    dsl/message/CfgNav5.xml
    dsl/message/CfgTp5.xml
    dsl/message/CfgPm.xml
    dsl/message/CfgRinv.xml
    dsl/message/CfgItfm.xml
    dsl/message/CfgPm2.xml
    dsl/message/CfgTmode2.xml
    dsl/message/CfgGnss.xml
    dsl/message/CfgLogfilter.xml
    dsl/message/CfgTxslot.xml
)

string(REPLACE ";" "\n" schema_files_str "${schema_files}")
set (schema_files_list_file "${CMAKE_BINARY_DIR}/schema_files.txt")
file(WRITE ${schema_files_list_file} "${schema_files_str}")


set (tmp_dir "${CMAKE_BINARY_DIR}/output.tmp")
set (code_input_dir "${CMAKE_SOURCE_DIR}/src")

if ("${OUTPUT_DIR}" STREQUAL "")
    set (OUTPUT_DIR "${CMAKE_BINARY_DIR}/output")
endif ()

file (GLOB_RECURSE src_files ${code_input_dir})

set (extra_dep)
if (TARGET ${COMMSDSL_TGT})
    set (extra_dep ${COMMSDSL_TGT})
endif ()

add_custom_target("rm_tmp_tgt"
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${tmp_dir}
)

add_custom_command(
    OUTPUT ${tmp_dir}
    DEPENDS ${schema_files} ${src_files} ${schema_files_list_file} ${extra_dep} "rm_tmp_tgt"
    COMMAND ${COMMSDSL2COMMS} ${COMMSDSL2COMMS_EXTRA_ARGS} --warn-as-err -o ${tmp_dir} 
        -c ${code_input_dir} -p ${CMAKE_SOURCE_DIR} -i ${schema_files_list_file}
)

set (output_tgt ${name}_output_tgt)
add_custom_target(${PROJECT_NAME} ALL
    COMMAND ${CMAKE_COMMAND}
        -DGENERATED="${tmp_dir}" -DOUTPUT="${OUTPUT_DIR}"
        -P "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake"
    DEPENDS ${tmp_dir} "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake" ${schema_files} ${src_files})


