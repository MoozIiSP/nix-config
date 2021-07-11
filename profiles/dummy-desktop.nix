{ config, pkgs, lib, ... }:

let
  inherit (lib) optionals;
in {
  # use elementarys pantheon desktop environment
  services.xserver.enable = lib.mkDefault true;
  services.xserver.useGlamor = true;
  services.xserver.displayManager.lightdm.enable = lib.mkDefault true;
  # services.xserver.desktopManager.pantheon.enable = lib.mkDefault true;

  # disable xterm session
  services.xserver.desktopManager.xterm.enable = true;
}