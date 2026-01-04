#!/bin/bash
# install Host packages for FCOS support
set -xeuo pipefail
pkgs="butane jq coreos-installer sscg yamllint"
sd=
[ `id -u` -eq 0 ] || sd=sudo
rpm -q $pkgs || $sd dnf install $pkgs
exit 0
