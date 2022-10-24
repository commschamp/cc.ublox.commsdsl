#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$( dirname ${SCRIPT_DIR} )

if [ -z ${BUILD_DIR} ]; then
    export BUILD_DIR="${ROOT_DIR}/build.full.basic.${CC}"
fi

${SCRIPT_DIR}/full_debug_build.sh -DUBLOX_SCHEMA_FILES_LIST_FILE=${ROOT_DIR}/basic_msgs.txt "$@"
