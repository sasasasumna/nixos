# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot = {
    supportedFilesystems = [ "btrfs" ];

    loader = {
      ef = {
        canTouchEfiVariables = true;
        efiSysMountpoint = "/boot";
      };

      systemd-boot.enable = true;
    };

    initrd = {
      luks.devices.crypt = {
        allowDiscards = true;
        device = "/dev/disks/by-label/crypt";
      };

      postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs /dev/mapper/crypt /mnt
        btrfs subvolume delete /mnt/
        btrfs subvolume snapshot /mnt/blank /mnt/
      '';
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/" ];
    };

    "/home" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/home" ];
    };

    "/nix" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/nix" ];
    };

    "/var/lib/docker" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/var/lib/docker" ];
    };

    "/var/lib/machines" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/var/lib/machines" ];
    };

    "/var/log" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "ssd" "rw" "noatime" "discard=async" "compress=zstd" "space_cache=v2" "commit=120" "subvol=/var/log" ];
    };

    "/swap" = {
      device = "/dev/mapper/root";
      options = [ "ssd" "noatime" "discard=async" "subvol=/swap" ];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
    }
  ]

  hardware.enableAllFirmware = true;

  nixpkgs.config.allowUnfree = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
