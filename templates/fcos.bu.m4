# Butane file for FCOS: "FCOS_HOSTNAME"
---
variant: fcos
version: 1.6.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - "FCOS_SSH_PUBKEY"
storage:
  files:
    - path: /etc/hostname
      mode: 0644
      overwrite: true
      contents:
        inline: "FCOS_HOSTNAME"
