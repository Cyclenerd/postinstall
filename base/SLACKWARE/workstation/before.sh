#
# before.sh for SLACKWARE and all TYPEs
#

#
# Disable upgrade kernel before running slackpkg

sed -i '17,25 s/^#//' /etc/slackpkg/blacklist
