# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./common.nix
    ];


  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
    "gccarch-znver5"
  ];

  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

#  # Suspend first then hibernate when closing the lid
#  services.logind.lidSwitch = "suspend-then-hibernate";
#  services.logind.lidSwitchExternalPower = "lock";
# 
#  # Hibernate on power button pressed
#  services.logind.powerKey = "hibernate";
#  services.logind.powerKeyLongPress = "poweroff";

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];

#   # Define time delay for hibernation
#   systemd.sleep.extraConfig = ''
#     HibernateDelaySec=30m
#     SuspendState=mem
#   '';

  networking.hostName = "Adam-Sumner";

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  boot.initrd.availableKernelModules = [ "btrfs" "nvme" "xhci_pci" "thunderbolt" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "kvm-amd" "amdgpu" "radeon" "thunderbolt" "xhci_pci" "nvme" "btrfs" ];
  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/35ff357b-980f-475f-80c1-924a33e14bc2";
  #boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/d5c7165d-7b30-4109-b8c1-96964024dbb8";
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/385cd6a9-d389-4c38-97ac-bd809bba179d";
      fsType = "btrfs";
      options = [ "defaults,ssd,subvol=@root,compress=zstd:1,discard=async" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2CD8-4135";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/385cd6a9-d389-4c38-97ac-bd809bba179d";
      fsType = "btrfs";
      options = [ "defaults,ssd,subvol=@home,compress=zstd:1,discard=async" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/385cd6a9-d389-4c38-97ac-bd809bba179d";
      fsType = "btrfs";
      options = [ "defaults,ssd,subvol=@nix,compress=zstd:1,discard=async" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/385cd6a9-d389-4c38-97ac-bd809bba179d";
      fsType = "btrfs";
      options = [ "defaults,ssd,subvol=@docker,compress=zstd:1,discard=async" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/385cd6a9-d389-4c38-97ac-bd809bba179d";
      fsType = "btrfs";
      options = [ "defaults,ssd,subvol=@log,compress=zstd:1,discard=async" ];
    };

#  swapDevices =
#    [ { device = "/dev/disk/by-uuid/5627e916-eebf-410c-86a0-31149892191c"; }
#    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
