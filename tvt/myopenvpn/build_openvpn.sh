#!/bin/sh
dockerfile() {
#
# docker pull alpine
# docker build -t myopenvpn -<myopenvpn
# docker run --cap-add=NET_ADMIN --name=openvpn-svr --rm -it -p 5005:5005 -v "$(pwd)":/etc/openvpn myopenvpn
# docker run --cap-add=NET_ADMIN --name=openvpn-svr -d --restart=always -p 5005:5005 -v "$(pwd)":/etc/openvpn myopenvpn
#
FROM alpine
RUN
CMD ["startup"]
VOLUME ["/etc/openvpn"]
}
set -eu

apk add --no-cache openvpn

# Cleanup unwanted openvpn data
rm -rf \
    /etc/*- \
    /etc/openvpn/down.sh \
    /etc/openvpn/up.sh

cat >/usr/local/bin/startup<<\@
#!/bin/sh -

[ "$$" != 1 ] && {
    OPENVPN="${1:-/etc/openvpn}"
    cd "${OPENVPN}"
    exec openvpn --config "${OPENVPN}/openvpn.conf"
}

# Not added automatically by alpine.
[ ! -c /dev/net/tun ] && {
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
}

# Permissions ?
iptables -L -n >/dev/null || {
    echo >&2 'Note: This needs "iptables-legacy" and --cap-add=NET_ADMIN'
    exit 1
}

# Routing will not be configured.
iptables -w -t nat -C POSTROUTING -o eth+ -j MASQUERADE 2>/dev/null ||
      iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE

iptables -w -t nat -C POSTROUTING -o tun+ -j MASQUERADE 2>/dev/null ||
      iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE

################################################################################

OPENVPN=/etc/openvpn
OPENVPNCONF="${OPENVPN}/openvpn.conf"

[ -f "${OPENVPN}/configure.sh" ] &&
    . "${OPENVPN}/configure.sh"

for i in "${OPENVPNCONF}" "${OPENVPN}"/*/openvpn.conf
do  [ -e "$i" ] || continue
    j=$(dirname "$i")
    echo "::respawn:/usr/local/bin/startup '$j'"
    [ -f "$j"/startup.sh ] && sh "$j"/startup.sh
done > /etc/inittab

[ -s /etc/inittab ] && {
    echo '::ctrlaltdel:/sbin/halt' >> /etc/inittab
    exec init
}

echo >&2 OpenVPN configuration not found.
exit 1
@
chmod 755 /usr/local/bin/startup
exit 0
