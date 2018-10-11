#
# after.sh for DEBIAN and TYPE=server
#


#
# Edit local fail2ban customizations for jail.conf
#

echo_step "  Edit fail2ban customizations for jail.conf"
cat > "/etc/fail2ban/jail.local" <<EOL
[DEFAULT]
bantime   = 90m
destemail = root@localhost
sender    = root@localost
action    = %(action_mwl)s

[sshd]
enabled   = true
port      = ssh,222
echo_success

EOL