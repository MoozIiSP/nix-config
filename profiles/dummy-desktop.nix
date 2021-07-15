{ config, pkgs, lib, ... }:

let
  inherit (lib) optionals;
in {
  # Enable the X11 windowing system.
  services.xserver.enable = lib.mkDefault true;
  services.xserver.displayManager.startx.enable = lib.mkDefault true;
  # services.xserver.displayManager.lightdm.enable = lib.mkDefault true;
  services.xserver.desktopManager.xterm.enable = lib.mkDefault true;
}