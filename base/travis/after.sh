#
# after.sh for all OPERATING_SYSTEMs and TYPE=travis
#

# Only for travis build test
echo_step "  Create /tmp/done file"
if echo -n "done" > "/tmp/done"; then
	echo_success
else
	echo_warning "Failed, will attempt to continue"
fi