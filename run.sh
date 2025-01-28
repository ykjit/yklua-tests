#!/bin/sh
#
# Runs all tests suites with the specified Lua interpreter.

set -eu

if [ $# -ne 1 ]; then
    printf "usage: run.sh <lua-binary>\n"
    printf "\nThis must be run from the same directory as the script.\n"
    exit 1
fi

LUA=$1
TOP=$(pwd)

for suite in suites/*; do
    printf "\n==> Running suite in %s\n" "${suite}"
    cd "${suite}"
    sh run.sh "${LUA}"
    cd "${TOP}"
done
