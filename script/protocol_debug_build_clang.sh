#!/bin/bash

export CC=clang
export CXX=clang++

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "SCRIPT_DIR=${SCRIPT_DIR}"
${SCRIPT_DIR}/protocol_debug_build.sh "$@"

