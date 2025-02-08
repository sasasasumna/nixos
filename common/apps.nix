# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./apps/firefox.nix
      ./apps/home-manager.nix
      ./apps/vim.nix
    ];

  environment.systemPackages = with pkgs; [
    git
    htop
    code-cursor
    curl
    ghostty
    slack
    vivaldi
    vivaldi-ffmpeg-codecs
    vim 
    wget
    zoom-us
    zsh
  ];
}

