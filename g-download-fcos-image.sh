#!/bin/bash
# download "golden" FCOS image (VMs will store differential files only)
# from: https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/
set -euo pipefail
# allow override
: ${STREAM:=stable}

errx ()
{
	echo "ERROR: $*" >&2
	exit 1
}

[[ $STREAM =~ ^(stable|testing|next)$ ]] || errx "Invalid STREAM='$STREAM' - must be stable, testing or next"
set -x
dt="$HOME/.local/share/libvirt/images"
[ -d "$dt" ] || {
	mkdir -p "$dt"
	setfacl -m u:qemu:x $HOME
	setfacl -m u:qemu:x $HOME/.local
	setfacl -m u:qemu:x $HOME/.local/share
	setfacl -m u:qemu:x $HOME/.local/share/libvirt
	setfacl -m u:qemu:rwx $HOME/.local/share/libvirt/images
}
coreos-installer download -s $STREAM -p qemu -f qcow2.xz --decompress -C ~/.local/share/libvirt/images/
# Note: above file will be used as "backing store" (golden image) - should be never modified!
# Quick backup:
zstdmt -v ~/.local/share/libvirt/images/fedora-coreos-*-qemu.x86_64.qcow2
set +x
exit 0
