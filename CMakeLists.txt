cmake_minimum_required (VERSION 3.5)
project ("cc.ublox.commsdsl")

option (UBLOX_NO_EXAMPLES "Disable examples compilation." OFF)
option (UBLOX_NO_WARN_AS_ERR "Don't treat compilation warnings as errors." OFF)
option (UBLOX_USE_CCACHE "Use ccache on UNIX." ON)
option (UBLOX_BUILD_GEN_PROTOCOL "Build and install generated protocol" ON)
option (UBLOX_BUILD_GEN_DOC "Build documentation for generated protocol" OFF)
option (UBLOX_BUILD_GEN_TEST "Build and install generated test application" OFF)
option (UBLOX_BUILD_GEN_TOOLS "Build and install generated plugin for tools" OFF)

# Additional variables to be used if needed
# ---------------------------
# UBLOX_PROT_OUTPUT_DIR - Path to protocol output directory. If not provided <build_dir>/output one is used.
# UBLOX_TEST_OUTPUT_DIR - Path to test output directory. If not provided <build_dir>/output_tools one is used.
# UBLOX_TOOLS_OUTPUT_DIR - Path to tools output directory. If not provided <build_dir>/output_tools one is used.
# COMMSDSL2COMMS_EXTRA_ARGS - Extra arguments to pass to "commsdsl2comms"
# COMMSDSL2TEST_EXTRA_ARGS - Extra arguments to pass to "commsdsl2test"
# COMMSDSL2TOOLS_QT_EXTRA_ARGS - Extra arguments to pass to "commsdsl2tools_qt"

set (VERSION "1.1.0")

set (EXTERNALS_DIR "${PROJECT_SOURCE_DIR}/externals")

find_program(COMMSDSL2COMMS commsdsl2comms PATH_SUFFIXES bin REQUIRED)        
find_program(COMMSDSL2TEST commsdsl2test PATH_SUFFIXES bin REQUIRED)        
find_program(COMMSDSL2TOOLS_QT commsdsl2tools_qt PATH_SUFFIXES bin REQUIRED)      

set (PROT_OUTPUT_TGT "${PROJECT_NAME}_prot_output_tgt")


set (schema_files
    dsl/main.xml
    dsl/field/common.xml
    dsl/field/cfgval.xml
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
    dsl/message/NavSlas.xml
    dsl/message/NavSig.xml
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
    dsl/message/CfgPwr.xml
    dsl/message/CfgHnr.xml
    dsl/message/CfgEsrc.xml
    dsl/message/CfgDosc.xml
    dsl/message/CfgSmgr.xml
    dsl/message/CfgGeofence.xml
    dsl/message/CfgDgnss.xml
    dsl/message/CfgTmode3.xml
    dsl/message/CfgFixseed.xml
    dsl/message/CfgPms.xml
    dsl/message/CfgValset.xml
    dsl/message/CfgValget.xml
    dsl/message/CfgValdel.xml
    dsl/message/UpdSos.xml
    dsl/message/MonIo.xml
    dsl/message/MonVer.xml
    dsl/message/MonMsgpp.xml
    dsl/message/MonRxbuf.xml
    dsl/message/MonTxbuf.xml
    dsl/message/MonHw.xml
    dsl/message/MonHw2.xml
    dsl/message/MonRxr.xml
    dsl/message/MonPatch.xml
    dsl/message/MonGnss.xml
    dsl/message/MonSmgr.xml
    dsl/message/MonSpan.xml
    dsl/message/MonComms.xml
    dsl/message/MonHw3.xml
    dsl/message/MonRf.xml
    dsl/message/AidReq.xml
    dsl/message/AidIni.xml
    dsl/message/AidHui.xml
    dsl/message/AidData.xml
    dsl/message/AidAlm.xml
    dsl/message/AidEph.xml
    dsl/message/AidAlpsrv.xml
    dsl/message/AidAop.xml
    dsl/message/AidAlp.xml
    dsl/message/TimTp.xml
    dsl/message/TimTm2.xml
    dsl/message/TimSvin.xml
    dsl/message/TimVrfy.xml
    dsl/message/TimDosc.xml
    dsl/message/TimTos.xml
    dsl/message/TimSmeas.xml
    dsl/message/TimVcocal.xml
    dsl/message/TimFchg.xml
    dsl/message/EsfMeas.xml
    dsl/message/EsfRaw.xml
    dsl/message/EsfStatus.xml
    dsl/message/EsfIns.xml
    dsl/message/MgaGps.xml
    dsl/message/MgaGal.xml
    dsl/message/MgaBds.xml
    dsl/message/MgaQzss.xml
    dsl/message/MgaGlo.xml
    dsl/message/MgaAno.xml
    dsl/message/MgaFlash.xml
    dsl/message/MgaIni.xml
    dsl/message/MgaAck.xml
    dsl/message/MgaDbd.xml
    dsl/message/LogErase.xml
    dsl/message/LogString.xml
    dsl/message/LogCreate.xml
    dsl/message/LogInfo.xml
    dsl/message/LogRetrieve.xml
    dsl/message/LogRetrievepos.xml
    dsl/message/LogRetrievestring.xml
    dsl/message/LogFindtime.xml
    dsl/message/LogRetrieveposextra.xml
    dsl/message/LogRetrievebatch.xml
    dsl/message/LogBatch.xml
    dsl/message/SecSign.xml
    dsl/message/SecUniqid.xml
    dsl/message/HnrPvt.xml
)

string(REPLACE ";" "\n" schema_files_str "${schema_files}")
set (schema_files_list_file "${CMAKE_BINARY_DIR}/schema_files.txt")
file(WRITE ${schema_files_list_file} "${schema_files_str}")


set (prot_tmp_dir "${CMAKE_BINARY_DIR}/output.tmp")
set (test_tmp_dir "${CMAKE_BINARY_DIR}/output_test.tmp")
set (tools_tmp_dir "${CMAKE_BINARY_DIR}/output_tools.tmp")
set (code_input_dir "${CMAKE_SOURCE_DIR}/src")

if ("${UBLOX_PROT_OUTPUT_DIR}" STREQUAL "")
    set (UBLOX_PROT_OUTPUT_DIR "${CMAKE_BINARY_DIR}/output")
endif ()

if ("${UBLOX_TEST_OUTPUT_DIR}" STREQUAL "")
    set (UBLOX_TEST_OUTPUT_DIR "${CMAKE_BINARY_DIR}/output_test")
endif ()

if ("${UBLOX_TOOLS_OUTPUT_DIR}" STREQUAL "")
    set (UBLOX_TOOLS_OUTPUT_DIR "${CMAKE_BINARY_DIR}/output_tools")
endif ()

set (warn_as_error "--warn-as-err")
if (UBLOX_NO_WARN_AS_ERR)
    set (warn_as_error)
endif ()

add_custom_target(rm_tmp_tgt
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${prot_tmp_dir}
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${test_tmp_dir}
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${tools_tmp_dir}
)

add_custom_command(
    OUTPUT ${prot_tmp_dir}
    DEPENDS ${schema_file} ${src_files} rm_tmp_tgt
    COMMAND ${COMMSDSL2COMMS} ${warn_as_error} -V ${VERSION}
        -o ${prot_tmp_dir} 
        -c ${code_input_dir} -p ${CMAKE_SOURCE_DIR} -i ${schema_files_list_file} 
        ${COMMSDSL2COMMS_EXTRA_ARGS} 
)

add_custom_command(
    OUTPUT ${test_tmp_dir}
    DEPENDS ${schema_file} ${src_files} ${extra_dep} rm_tmp_tgt
    COMMAND ${COMMSDSL2TEST} ${warn_as_error} -p ${CMAKE_SOURCE_DIR}
        -i ${schema_files_list_file} ${COMMSDSL2TEST_EXTRA_ARGS} -o ${test_tmp_dir}
)

add_custom_command(
    OUTPUT ${tools_tmp_dir}
    DEPENDS ${schema_file} ${src_files} ${extra_dep} rm_tmp_tgt
    COMMAND ${COMMSDSL2TOOLS_QT} ${warn_as_error} -p ${CMAKE_SOURCE_DIR}
        -i ${schema_files_list_file} ${COMMSDSL2TOOLS_QT_EXTRA_ARGS} -o ${tools_tmp_dir} 
)

set (readme_file "${prot_tmp_dir}/README.md")
add_custom_command(
    OUTPUT ${readme_file}
    DEPENDS ${prot_tmp_dir} 
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/readme.generated ${readme_file}
)

add_custom_target(${PROT_OUTPUT_TGT} ALL
    COMMAND ${CMAKE_COMMAND}
        -DGENERATED="${prot_tmp_dir}" -DOUTPUT="${UBLOX_PROT_OUTPUT_DIR}"
        -P "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake"
    COMMAND ${CMAKE_COMMAND}
        -DGENERATED="${test_tmp_dir}" -DOUTPUT="${UBLOX_TEST_OUTPUT_DIR}"
        -P "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake"        
    COMMAND ${CMAKE_COMMAND}
        -DGENERATED="${tools_tmp_dir}" -DOUTPUT="${UBLOX_TOOLS_OUTPUT_DIR}"
        -P "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake"        
    DEPENDS ${prot_tmp_dir} ${test_tmp_dir} ${tools_tmp_dir} ${readme_file} "${CMAKE_CURRENT_LIST_DIR}/CopyGenerated.cmake" ${schema_file})

include (ExternalProject)
if (UBLOX_BUILD_GEN_PROTOCOL)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory ${UBLOX_PROT_OUTPUT_DIR}
    )  

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E touch ${UBLOX_PROT_OUTPUT_DIR}/dummy.txt
    )

    set (prot_build_dir ${CMAKE_CURRENT_BINARY_DIR}/prot_tgt_build)
    ExternalProject_Add(
        "prot_tgt"
        BUILD_ALWAYS TRUE
        DEPENDS ${PROT_OUTPUT_TGT}
        SOURCE_DIR ${UBLOX_PROT_OUTPUT_DIR}
        BINARY_DIR ${prot_build_dir}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_GENERATOR ${CMAKE_GENERATOR}
        CMAKE_ARGS
            -DOPT_REQUIRE_COMMS_LIB=OFF
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    )

    find_package(Doxygen)
    if (UBLOX_BUILD_GEN_DOC AND DOXYGEN_FOUND)
        ExternalProject_Add_Step(
            "prot_tgt" 
            "doc"
            COMMAND ${CMAKE_COMMAND} --build ${prot_build_dir} --target doc_ublox
            DEPENDEES "build"
            DEPENDERS "install"
        )
    endif ()
endif ()  

set (combined_prefix_path ${CMAKE_INSTALL_PREFIX} ${CMAKE_PREFIX_PATH})
string (REPLACE ";" "|" combined_prefix_path_str "${combined_prefix_path}")

if (UBLOX_BUILD_GEN_TEST)
    if (NOT UBLOX_BUILD_GEN_PROTOCOL)
        message (FATAL_ERROR "UBLOX_BUILD_GEN_PROTOCOL is required for UBLOX_BUILD_GEN_TEST")
    endif ()

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory ${UBLOX_TEST_OUTPUT_DIR}
    )

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E touch ${UBLOX_TEST_OUTPUT_DIR}/dummy.txt
    )

    set (test_build_dir ${CMAKE_CURRENT_BINARY_DIR}/test_tgt_build)
    ExternalProject_Add(
        "test_tgt"
        BUILD_ALWAYS TRUE
        DEPENDS "prot_tgt"
        SOURCE_DIR ${UBLOX_TEST_OUTPUT_DIR}
        BINARY_DIR ${test_build_dir}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_GENERATOR ${CMAKE_GENERATOR}
        LIST_SEPARATOR |
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_PREFIX_PATH=${combined_prefix_path_str}
    )   
endif ()


if (UBLOX_BUILD_GEN_TOOLS)
    if (NOT UBLOX_BUILD_GEN_PROTOCOL)
        message (FATAL_ERROR "UBLOX_BUILD_GEN_PROTOCOL is required for UBLOX_BUILD_GEN_TOOLS")
    endif ()

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E make_directory ${UBLOX_TOOLS_OUTPUT_DIR}
    )    

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E touch ${UBLOX_TOOLS_OUTPUT_DIR}/dummy.txt
    )

    set (tools_build_dir ${CMAKE_CURRENT_BINARY_DIR}/tools_tgt_build)
    ExternalProject_Add(
        "tools_tgt"
        BUILD_ALWAYS TRUE
        DEPENDS "prot_tgt"
        SOURCE_DIR ${UBLOX_TOOLS_OUTPUT_DIR}
        BINARY_DIR ${tools_build_dir}
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_GENERATOR ${CMAKE_GENERATOR}
        LIST_SEPARATOR |
        CMAKE_ARGS
            -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_PREFIX_PATH=${combined_prefix_path_str}
    )   
endif ()

if (UBLOX_NO_EXAMPLES)
    return ()
endif ()

add_subdirectory (examples)
