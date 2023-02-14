{ config, lib, pkgs, ... }:
with lib;
{
  options = {
    services.zerotier = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Whether to enable the zerotier.
        '';
      };
    };
  };


}
