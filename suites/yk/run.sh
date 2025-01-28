#!/bin/sh
#
# Runs all tests with the specified Lua interpreter.

set -eu

TESTDIR=tests
TESTFILES=bounce_onefile.lua

# The number of times to repeat each test.
#
# We repeat to try and shake out non-deterministic problems.
REPS=10

if [ $# -ne 1 ]; then
    echo "usage: run.sh <lua-binary>"
    exit 1
fi
LUA=$1

# Get a list of iteration counts to test.
#
# Sets $param_list with a space separated list of parameters to try each test
# with. Currently each test accepts exactly one parameter, so each item in
# $param_list coresponds with one execution of the test file.
param_list=
get_params() {
    case $1 in
        bounce_onefile.lua) param_list="50 100 1000";;
        *)
            echo "failed to get iteration counts for $1"
            exit 1
            ;;
    esac
}

failed=
for f in ${TESTFILES}; do
    get_params "$f"
    for param in ${param_list}; do
        for rep in $(seq ${REPS}); do
            echo "-> Running $f/${param} (${rep}/${REPS})"

            set +e
            ${LUA} ${TESTDIR}/"$f" "${param}"
            result=$?
            set -e

            if [ "${result}" -ne 0 ]; then
                echo "FAIL"
                failed="${failed} $f/${param}"
                break
            fi
        done
    done
done

if [ -n "${failed}" ]; then
    printf "\n\nThe following tests failed: %s\n" "${failed}"
    exit 1
fi
