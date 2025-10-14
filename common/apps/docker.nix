{ config, pkgs, ... }:

{
  virtualisation.docker = {
    autoPrune.enable = true;
    daemon.settings = {
      data-root = "/var/lib/docker";
    };
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
