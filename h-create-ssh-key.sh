#!/bin/bash
# create SSH keypair used to access FCOS target VMs. Run on Fedora host.
set -euo pipefail
# private key (pk)
# Note: use subdir "keys", because SSH automatically tries all keys right under ~/.ssh/ dir (!)
pk=$HOME/.ssh/keys/id_ed25519_fcos 

errx ()
{
	echo "ERROR: $*" >&2
	exit 1
}

# fail with error of SSH key already exists
[  -r "$pk" -o -r "$pk.pub"  ] && errx "SSH private key file '$pk' already exists" || true
set -x
mkdir -p $(dirname "$pk")
# tighten permissions, otherwise SSH may complain and avoid using keys in
chmod 700 $(dirname "$pk")
ssh-keygen -t ed25519 -f "$pk" -N ''
set +x
echo "Generated new SSH keypair:"
file "$pk" "$pk.pub"
exit 0
