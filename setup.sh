#!/bin/bash

MACHINE=$1

if [ -e "${MACHINE}.nix" ]; then
  if [ -e "${MACHINE}/hardware-configuration.nix" ]; then
    ln -sf $1/hardware-configuration.nix ./hardware-configuration.nix
    ln -sf $1.nix ./configuration.nix
    exit 0
  fi
fi

echo "$0 is for properly linking NixOS configurations for <machine>"
echo "<machine> can be one of devbox, laptop, or workstation."
echo "error: illegal machine '$1'"
echo "usage: $0 <machine>"
echo "Expects $1.nix and $1/hardware-configuration.nix to exist."
