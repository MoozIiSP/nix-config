{ config, pkgs, ... }:

let
  customFontPkgs = [
    (import ../../packges/font/sarasa-gothic {})
  ];
in {
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      fira-mono
      libertine
      open-sans
      twemoji-color-font
      liberation_ttf
    ] ++ customFontPkgs;

    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [ "Fira Mono" ];
        serif = [ "Linux Libertine" ];
        sansSerif = [ "Open Sans" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}