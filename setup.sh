#!/bin/bash

MACHINE=$1

if [ -e "${MACHINE}.nix" ]; then
  # TODO: fix home-manager integration, it is not found in PATH
  # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  # nix-channel --update

  ln -sf $1.nix ./configuration.nix
  exit 0
fi

echo "$0 is for properly linking NixOS configurations for <machine>"
echo "<machine> can be one of devbox, laptop, or workstation."
echo "error: illegal machine '$1'"
echo "usage: $0 <machine>"
echo "Expects $1.nix and $1/hardware-configuration.nix to exist."
