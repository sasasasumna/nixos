# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./apps/firefox.nix
      ./apps/vim.nix
      ./apps/vivaldi.nix
    ];

  environment.systemPackages = with pkgs; [
    git
    htop
    code-cursor
    curl
    ghostty
    slack
    vim 
    wget
    zoom-us
  ];
}

