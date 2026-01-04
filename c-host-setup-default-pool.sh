#!/bin/bash
set -euo pipefail
# create "default" storage pool if it does not exist yet:
virsh pool-list --name | tr '\n' ' ' | grep -w default  || {
	echo "INFO: Creating pool 'default' in '/var/lib/libvirt/images'"
	virsh pool-define-as default dir - - - - "/var/lib/libvirt/images"
	virsh pool-autostart default
	virsh pool-start default
}
exit 0

