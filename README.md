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

# Create FCOS VM

Use following script to create VM named `fcos-01`:

```shell
./r-create-fcos-vm.sh fcos-01
```

WARNING! If you get error on `virbr0` - you have to wait several
seconds until it is initialized (new LibVirt uses lazy initialization, which
is a bit unreliable) - for example with command:

```shell
$ ip -br -4 a | grep virbr0

virbr0           UP             192.168.122.1/24 
```

It must be `UP` and having assigned IP address as shown above. If not wait
several seconds and repeat that command. And then repeat
your command, for example:

```shell
./r-create-fcos-vm.sh fcos-01
```

Once FCOS installation is finished you will see `login:` prompt.

Press `Ctrl`-`]` to exist serial console - this will finish `virt-install`
command and returns to shell.

To access this new Fedora Core OS image try:

```shell
ssh -i ~/.ssh/keys/id_ed25519_fcos core@fcos-01
```

You can use:
- `sudo bash` to become root
- `sudo poweroff` to shutdown VM


# Resources

* https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/
* https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/
