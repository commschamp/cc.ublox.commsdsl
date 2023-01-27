#!/bin/bash

# Input
# BUILD_DIR - Main build directory
# CC - Main C compiler
# CXX - Main C++ compiler
# CC_COMMSDSL - C compiler for commsdsl
# CXX_COMMSDSL - C++ compiler for commsdsl
# EXTERNALS_DIR - (Optional) Directory where externals need to be located
# COMMS_REPO - (Optional) Repository of the COMMS library
# COMMS_TAG - (Optional) Tag of the COMMS library
# COMMSDSL_REPO - (Optional) Repository of the commsdsl code generators
# COMMSDSL_TAG - (Optional) Tag of the commdsl
# CC_TOOLS_QT_REPO - (Optional) Repository of the cc_tools_qt
# CC_TOOLS_QT_TAG - (Optional) Tag of the cc_tools_qt
# CC_TOOLS_QT_SKIP - (Optional) Skip build of cc_tools_qt
# COMMON_INSTALL_DIR - (Optional) Common directory to perform installations
# COMMON_BUILD_TYPE - (Optional) CMake build type
# COMMON_CXX_STANDARD - (Optional) CMake C++ standard

#####################################

if [ -z "${BUILD_DIR}" ]; then
    echo "BUILD_DIR hasn't been specified"
    exit 1
fi

if [ -z "${EXTERNALS_DIR}" ]; then
    EXTERNALS_DIR=${BUILD_DIR}/externals
fi

if [ -z "${COMMS_REPO}" ]; then
    COMMS_REPO=https://github.com/commschamp/comms.git
fi

if [ -z "${COMMS_TAG}" ]; then
    COMMS_TAG=master
fi

if [ -z "${COMMSDSL_REPO}" ]; then
    COMMSDSL_REPO=https://github.com/commschamp/commsdsl.git
fi

if [ -z "${COMMSDSL_TAG}" ]; then
    COMMSDSL_TAG=master
fi

if [ -z "${CC_TOOLS_QT_REPO}" ]; then
    CC_TOOLS_QT_REPO=https://github.com/commschamp/cc_tools_qt.git
fi

if [ -z "${CC_TOOLS_QT_TAG}" ]; then
    CC_TOOLS_QT_TAG=master
fi

if [ -z "${COMMON_BUILD_TYPE}" ]; then
    COMMON_BUILD_TYPE=Debug
fi

if [ -z "${CC_COMMSDSL}" ]; then
    CC_COMMSDSL=${CC}
fi

if [ -z "${CXX_COMMSDSL}" ]; then
    CXX_COMMSDSL=${CXX}
fi

COMMS_SRC_DIR=${EXTERNALS_DIR}/comms
COMMS_BUILD_DIR=${BUILD_DIR}/externals/comms/build
COMMS_INSTALL_DIR=${COMMS_BUILD_DIR}/install
if [ -n "${COMMON_INSTALL_DIR}" ]; then
    COMMS_INSTALL_DIR=${COMMON_INSTALL_DIR}
fi

COMMSDSL_SRC_DIR=${EXTERNALS_DIR}/commsdsl
COMMSDSL_BUILD_DIR=${BUILD_DIR}/externals/commsdsl/build
COMMSDSL_INSTALL_DIR=${COMMSDSL_BUILD_DIR}/install
if [ -n "${COMMON_INSTALL_DIR}" ]; then
    COMMSDSL_INSTALL_DIR=${COMMON_INSTALL_DIR}
fi

CC_TOOLS_QT_SRC_DIR=${EXTERNALS_DIR}/cc_tools_qt
CC_TOOLS_QT_BUILD_DIR=${BUILD_DIR}/externals/cc_tools_qt/build
CC_TOOLS_QT_INSTALL_DIR=${CC_TOOLS_QT_BUILD_DIR}/install
if [ -n "${COMMON_INSTALL_DIR}" ]; then
    CC_TOOLS_QT_INSTALL_DIR=${COMMON_INSTALL_DIR}
fi

procs=$(nproc)
if [ -n "${procs}" ]; then
    procs_param="-- -j${procs}"
fi

#####################################

function build_comms() {
    if [ -e ${COMMS_SRC_DIR}/.git ]; then
        echo "Updating COMMS library..."
        cd ${COMMS_SRC_DIR}
        git fetch --all
        git checkout .
        git checkout ${COMMS_TAG}
        git pull --all
    else
        echo "Cloning COMMS library..."
        mkdir -p ${EXTERNALS_DIR}
        git clone -b ${COMMS_TAG} ${COMMS_REPO} ${COMMS_SRC_DIR}
    fi

    echo "Building COMMS library..."
    mkdir -p ${COMMS_BUILD_DIR}
    cmake -S ${COMMS_SRC_DIR} -B ${COMMS_BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${COMMS_INSTALL_DIR} -DCMAKE_BUILD_TYPE=${COMMON_BUILD_TYPE} -DCMAKE_CXX_STANDARD=${COMMON_CXX_STANDARD}
    cmake --build ${COMMS_BUILD_DIR} --config ${COMMON_BUILD_TYPE} --target install ${procs_param}
}

function build_commsdsl() {
    if [ -e ${COMMSDSL_SRC_DIR}/.git ]; then
        echo "Updating commsdsl..."
        cd ${COMMSDSL_SRC_DIR}
        git fetch --all
        git checkout .
        git checkout ${COMMSDSL_TAG}
        git pull --all
    else
        echo "Cloning commsdsl ..."
        mkdir -p ${EXTERNALS_DIR}
        git clone -b ${COMMSDSL_TAG} ${COMMSDSL_REPO} ${COMMSDSL_SRC_DIR}
    fi

    echo "Building commsdsl ..."
    mkdir -p ${COMMSDSL_BUILD_DIR}
    CC=${CC_COMMSDSL} CXX=${CXX_COMMSDSL} cmake -S ${COMMSDSL_SRC_DIR} -B ${COMMSDSL_BUILD_DIR} \
        -DCMAKE_INSTALL_PREFIX=${COMMSDSL_INSTALL_DIR} -DCMAKE_BUILD_TYPE=${COMMON_BUILD_TYPE} \
        -DCOMMSDSL_INSTALL_LIBRARY=OFF -DCOMMSDSL_BUILD_COMMSDSL2TEST=ON -DCOMMSDSL_BUILD_COMMSDSL2TOOLS_QT=ON \
        -DCOMMSDSL_BUILD_COMMSDSL2SWIG=ON -DCOMMSDSL_BUILD_COMMSDSL2EMSCRIPTEN=ON
    cmake --build ${COMMSDSL_BUILD_DIR} --config ${COMMON_BUILD_TYPE} --target install ${procs_param}
}

function build_cc_tools_qt() {
    if [ -e ${CC_TOOLS_QT_SRC_DIR}/.git ]; then
        echo "Updating cc_tools_qt..."
        cd ${CC_TOOLS_QT_SRC_DIR}
        git fetch --all
        git checkout .
        git checkout ${CC_TOOLS_QT_TAG}
        git pull --all
    else
        echo "Cloning cc_tools_qt ..."
        mkdir -p ${EXTERNALS_DIR}
        git clone -b ${CC_TOOLS_QT_TAG} ${CC_TOOLS_QT_REPO} ${CC_TOOLS_QT_SRC_DIR}
    fi

    echo "Building cc_tools_qt ..."
    mkdir -p ${CC_TOOLS_QT_BUILD_DIR}
    cmake -S ${CC_TOOLS_QT_SRC_DIR} -B ${CC_TOOLS_QT_BUILD_DIR} -DCMAKE_INSTALL_PREFIX=${CC_TOOLS_QT_INSTALL_DIR} -DCMAKE_BUILD_TYPE=${COMMON_BUILD_TYPE} -DCC_TOOLS_QT_BUILD_APPS=OFF -DCC_TOOLS_QT_EXTERNAL_COMMS=ON -DCMAKE_PREFIX_PATH=${COMMS_INSTALL_DIR} -DCMAKE_CXX_STANDARD=${COMMON_CXX_STANDARD}
    cmake --build ${CC_TOOLS_QT_BUILD_DIR} --config ${COMMON_BUILD_TYPE} --target install ${procs_param}
}

set -e
export VERBOSE=1
build_comms
build_commsdsl

if [ -z "${CC_TOOLS_QT_SKIP}" ]; then
    build_cc_tools_qt
fi



