#!/bin/sh

set -eu

shellcheck run.sh
shellcheck suites/*/run.sh
shellcheck .buildbot.sh

# Run the tests with the same version of upstream Lua that yklua is based upon,
# just as a quick sanity check.
v=5.4.6
tb=lua-${v}.tar.gz
wget "https://lua.org/ftp/${tb}"
tar zxf ${tb}
cd lua-${v}
make -j "$(nproc)"
cd ..

for _ in $(seq 100); do
  sh run.sh "${PWD}/lua-${v}/src/lua"
  YKD_SERIALISE_COMPILATION=1 sh run.sh "${PWD}/lua-${v}/src/lua"
done
