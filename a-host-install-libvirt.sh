#!/bin/bash
set -xeuo pipefail
pkgs="libvirt-daemon-qemu libvirt-daemon-config-network libvirt-daemon-config-nwfilter virt-install"
sd=
[ `id -u` -eq 0 ] || sd=sudo
rpm -q $pkgs || {
       	$sd dnf install $pkgs
	set +x
	echo "WARNING: You should restart your Fedora Host system so LibVirt will be properly initialized"
}
exit 0
