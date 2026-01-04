#!/bin/bash
set -euo pipefail

errx ()
{
	echo "ERROR: $*" >&2
	exit 1
}

[ `id -u` -ne 0 ] || errx "This script must be run as non-root user but uid=0 detected"
f=$HOME/.config/libvirt/libvirt.conf
d=$( dirname $f )
set -x
[ -d "$d" ] || mkdir -vp "$d"
[ -f "$f" ] || {
cat > $f <<EOF
# use system-wide connections as default (otherwise session=user are used)
# see https://listman.redhat.com/archives/libvirt-users/2018-October/msg00067.html
uri_default = "qemu:///system"
EOF
set +x
echo "INFO: Created '$f' to use LibVirt system-wide connections as default"
set  -x
}

groups | grep -w libvirt || {
	sudo usermod -G libvirt -a $USER
	set +x
	echo "WARNING: You should relogin $USER to update 'libvirt' group membership"
	set -x
}
exit 0

