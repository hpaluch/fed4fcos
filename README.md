# Fedora for Fedora Core OS

Here is set of script to setup Fedora Host (Fedora 43 Server) to run Fedora
Core OS (FCOS) Virtual Machines (VMs) using LibVirt.

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

- on host install packages to support FCOS management:

  ```shell
  ./f-host-install-fcos-pkgs.sh
  ```

- download golden image of FCOS using:

  ```shell
  ./g-download-fcos-image.sh
  ```

- generate SSH keypair that will be used to access target FCOS VMs:

  ```shell
  ./h-create-ssh-key.sh
  ```


TODO...

# Resources

* https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/
* https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/
