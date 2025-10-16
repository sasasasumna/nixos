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
  # Suspend first then hibernate when closing the lid
  services.logind.lidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  networking.hostName = "Adam-laptop";

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
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4680be83-90f5-4eec-89a9-7647658f092e";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/469b30c9-25e7-42dd-9655-01c70fae196c";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7B61-39DA";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4680be83-90f5-4eec-89a9-7647658f092e";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/4680be83-90f5-4eec-89a9-7647658f092e";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/lib/docker" =
    { device = "/dev/disk/by-uuid/4680be83-90f5-4eec-89a9-7647658f092e";
      fsType = "btrfs";
      options = [ "subvol=@docker" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/4680be83-90f5-4eec-89a9-7647658f092e";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ac0256ea-024e-4c27-aa72-9eb89be30eed"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
