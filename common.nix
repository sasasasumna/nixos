{ config, lib, ... }:

{
  imports =
    [
      ./common/apps.nix
      ./common/fonts.nix
      ./common/programs.nix
      ./common/services.nix
      ./common/system.nix
      ./common/users.nix
      ./common/xserver.nix
    ];
}

