{ config, pkgs, ... }:

{
  virtualisation.docker = {
    autoPrune.enable = true;
    daemon.settings = {
      data-root = "/srv";
    };
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
