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
    dnsmasq
    doctl
    electron
    ffmpeg
    figma-linux
    fuse
    fuse3
    ghostty
    git
    go
    gtk2
    gtk3
    gtk4
    gzip
    hiredis
    htop
    imagemagick
    inetutils
    iputils
    keychain
    kubectl
    less
    linux-firmware
    linuxHeaders
    lz4
    mariadb
    mlocate
#    mongodb
    mtools
    openmpi
    openssl
    pciutils
    postgresql_13
    redis
    ripgrep
    slack
    spotify
    tmux
    unzip
    vim 
    vips
    wget
    xz
    zip
    zoom-us
  ];
}

