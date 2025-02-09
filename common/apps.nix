# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./apps/docker.nix
      ./apps/firefox.nix
      ./apps/steam.nix
      ./apps/vim.nix
      ./apps/vivaldi.nix
    ];

  environment.systemPackages = with pkgs; [
    bzip2
    code-cursor
    curl
    doctl
    figma-linux
    ghostty
    git
    htop
    keychain
    kubectl
    lz4
    openssl
    ripgrep
    slack
    spotify
    tmux
    vim 
    wget
    xz
    zoom-us
  ];
}

