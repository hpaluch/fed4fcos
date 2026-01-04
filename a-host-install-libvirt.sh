#!/bin/bash
set -xeuo pipefail
pkgs="libvirt-daemon-qemu libvirt-daemon-config-network libvirt-daemon-config-nwfilter virt-install libvirt-nss"
sd=
[ `id -u` -eq 0 ] || sd=sudo
rpm -q $pkgs || {
       	$sd dnf install $pkgs
	set +x
	echo "WARNING: You should restart your Fedora Host system so LibVirt will be properly initialized"
}

# enable auto-registration of VM_NAME as HOSTNAME for ping VM_NAME or SSH VM_NAME
authselect is-feature-enabled with-libvirt || {
	$sd authselect  enable-feature  with-libvir
}
exit 0
