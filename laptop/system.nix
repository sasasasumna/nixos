
# Changes related to hardware-configuration.nix

{ config, pkgs, lib, ... }:

{

  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "benchmark"
    "nixos-test"
    "gccarch-znver5"
  ];

  boot.initrd.kernelModules = [ "amdgpu" "radeon" ];

  services.power-profiles-daemon.enable = true;
  # Suspend first then hibernate when closing the lid
  services.logind.lidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';
}
