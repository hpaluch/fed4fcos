#!/bin/bash
# create FCOS VM
set -euo pipefail
app="$0"

errx ()
{
	echo "ERROR: $*" >&2
	exit 1
}

usage ()
{
	[ $# -eq 0 ] || echo "ERROR: $*" >&2
	cat >&2 <<EOF
Usage: $app VM_NAME
EOF
	exit  1
}

d=$( dirname $0 )
d=$( readlink -f "$d" )
template="$d/templates/fcos.bu.m4"
[ -f "$template" ] || errx "Internal error: template '$template' is not file"

[ $# -eq 1 ] || usage
VM_NAME="$1"
[[ $VM_NAME =~ ^[a-zA-Z][-0-9a-zA-Z.]+[0-9a-z]$ ]] || errx "VM_NAME='$VM_NAME' is invalid"

# detect existing VM, surround with spaces to avoid substring match
vms=" $( virsh list --all --name | tr '\n' ' ' ) "
echo "existing vms='$vms'"
if echo "$vms" | grep -q " $VM_NAME ";then
	errx "VM=' $VM_NAME ' already exists in list '$vms'"
fi

# public key (pk)
# Note: use subdir "keys", because SSH automatically tries all keys right under ~/.ssh/ dir (!)
pk_file=$HOME/.ssh/keys/id_ed25519_fcos.pub
# fail with error of SSH key already exists
[  -r "$pk_file" ] || errx "SSH public key file '$pk_file' does not exist - pleas run ./h-create-ssh-key.sh"

mkdir -p "$d/output"
b="$d/output/$VM_NAME.bu"

m4 -D FCOS_SSH_PUBKEY="$(cat $pk_file)" -D FCOS_HOSTNAME="$VM_NAME" "$template" | tee "$b"
"$d/utils/validate-yaml.sh" "$b"
i="$d/output/$VM_NAME.ign"

butane --pretty --strict "$b" > "$i"
jq < "$i"

IGNITION_CONFIG="$i"
# FIXME different image version
IMAGE="$HOME/.local/share/libvirt/images/fedora-coreos-43.20251120.3.0-qemu.x86_64.qcow2"
TARGET_IMAGE="$HOME/.local/share/libvirt/images/$VM_NAME.x86_64.qcow2"
VCPUS="2"
RAM_MB="2048"
STREAM="stable"
DISK_GB="10"

[ ! -f "$TARGET_IMAGE" ] || errx "Target image '$TARGET_IMAGE' already exists"

for i in "$IGNITION_CONFIG" "$IMAGE";do
	[ -r "$i" ] || errx "ERROR: file '$i' not readable" >&2
done

# Dump basic information on image
set -x
qemu-img info ~/.local/share/libvirt/images/fedora-coreos-43.20251120.3.0-qemu.x86_64.qcow2 | sed '/^Format/,$d'
set +x

IGNITION_DEVICE_ARG=(--qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}")

# Setup the correct SELinux label to allow access to the config
set -x
chcon --verbose --type svirt_home_t "${IGNITION_CONFIG}"
virt-install --connect="qemu:///system" --name="${VM_NAME}" --vcpus="${VCPUS}" --memory="${RAM_MB}" \
        --os-variant="fedora-coreos-$STREAM" --import --graphics=none \
        --disk="size=${DISK_GB},path=${TARGET_IMAGE},backing_store=${IMAGE}" \
        --network bridge=virbr0 "${IGNITION_DEVICE_ARG[@]}"
exit 0
