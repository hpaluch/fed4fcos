# Fedora for Fedora Core OS

Here is set of script to setup Fedora Host (Fedora 43 Server) to run Fedora
Core OS VMs using LibVirt.

# Setup

Requirements:
- Host Fedora 43 with KVM support - will run Fedora Core OS as Virtual Machines

One-time setup on host:
- prepare LibVirt with:

  ```shell
  ./a-host-install-libvirt.sh
  # now restart OS if new packages were installed with: sudo reboot
  # continue with:
  ./b-host-setup-libvirt-user.sh
  ./c-host-setup-default-pool.sh
  ```

- on host install packages to support CoreOS management:

  ```shell
  ./f-host-install-fcos-pkgs.sh
  ```

- generate SSH keypair that will be used to access target FCOS VMs:

  ```shell
  ./h-create-ssh-key.sh
  ```

TODO...
