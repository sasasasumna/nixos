# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "bluetooth" ];
    hashedPassword = "$6$D.6bS/u..fDpQjJV$d8b5MHIM8YYG9BROEPdb8G64bzlqrJKMqU7GLzdU97Xr4P71./JLjSaS.3ltjZT12IQW4uoy1WuGMudqSmN1I1";
    packages = with pkgs; [
      tree
    ];
  };
}
