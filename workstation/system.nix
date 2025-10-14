
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
}
