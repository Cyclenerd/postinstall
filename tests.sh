#!/usr/bin/env bash

# postinstall.sh Test Script
#
# https://github.com/lehmannro/assert.sh

source assert.sh

# `echo test` is expected to write "test" on stdout
assert "echo test" "test"
# `seq 3` is expected to print "1", "2" and "3" on different lines
assert "seq 3" "1\n2\n3"
# exit code of `true` is expected to be 0
assert_raises "true"
# exit code of `false` is expected to be 1
assert_raises "false" 1
# end of test suite
assert_end examples

echo
echo
echo "SET:"
echo
set

echo
echo
echo "INSTALL_LOG:"
echo
cat /tmp/install_*

echo
echo


echo
echo
echo "DONE:"
echo
cat /tmp/done
echo

assert "cat /tmp/done" "done"
assert_end postinstall_sh