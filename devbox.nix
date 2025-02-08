# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./devbox/system.nix
      ./devbox/nvidia.nix
      ./common.nix
    ];

  networking.hostName = "devbox";

  # Set your time zone.
  time.timeZone = "America/New_York";
}

