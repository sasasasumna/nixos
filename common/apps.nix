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

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.akonadi
    appimage-run
    avahi
    awscli2
    azure-cli
    bzip2
    code-cursor
    cpu-x
    curl
    dnsmasq
    doctl
    drm_info
    egl-wayland
    eksctl
    electron
    exfatprogs
    ffmpeg
    figma-linux
    flarectl
    fuse
    fuse3
    gearlever
    ghostty
    git
    go
    google-chrome
    gparted
    gpu-viewer
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
    libpulseaudio
    libGL
    libva-utils
    libxml2
    libxslt
    libyaml
    linux-firmware
    linuxHeaders
    lz4
    mariadb
    memcached
    mlocate
    mtools
    openmpi
    openssl
    pciutils
    qt5.full
    qt6.full
    rclone
    redis
    ripgrep
    slack
    spotify
    tmux
    traceroute
    unzip
    vdpauinfo
    vim 
    vips
    vlc
    vulkan-tools
    wget
    #wrangler
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    plasma5Packages.xdg-desktop-portal-kde
    xdg-desktop-portal-xapp
    xz
    zip
    zoom-us
  ];
}

