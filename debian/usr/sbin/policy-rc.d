#!/bin/sh

# For most Docker users, "apt-get install" only happens during "docker build",
# where starting services doesn't work and often fails in humorous ways. This
# prevents those failures by stopping the services from attempting to start.

case "$1" in
--list )
    echo >&2 "Everything is denied by policy."
    ;;
--quiet|'' )
    ;;
* ) echo >&2 "Denied: /usr/sbin/policy-rc.d $*"
    ;;
esac
exit 101 # action forbidden by policy
