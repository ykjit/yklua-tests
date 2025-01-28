#!/bin/sh

set -eu

shellcheck run.sh
shellcheck suites/*/run.sh
shellcheck .buildbot.sh
sh run.sh /usr/bin/lua5.3
