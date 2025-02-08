
# Changes related to hardware-configuration.nix

{ config, pkgs, lib, ... }:

{

  fileSystems."/" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/home" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/nix" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/etc/nixos" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/var/log" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      };

}
