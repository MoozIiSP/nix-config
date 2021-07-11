{ config, pkgs, lib, ... }:

let
  secrets = import ./secrets.nix;
in
{
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = lib.mkDefault false;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ secrets.ryzenserver ];
}