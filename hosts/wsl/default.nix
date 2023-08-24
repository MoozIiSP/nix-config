{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ./bocft-dev.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "mooziisp";
    startMenuLaunchers = true;

    # When install stage, wsl will throw a exception to deny boot.
    # nativeSystemd = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;
  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users = {
    # Using a purely declarative user setup. This means any future users will have to
    # have a password hash generated with `mkpasswd`
    #mutableUsers = false;
    # security
    # Needs to be set explicitly because nixos-wsl disables this for ease of installation
    #security.sudo.wheelNeedsPassword = true;
    # users
    users = {
      root.hashedPassword = "$6$MzkWefhNrnurSwZV$WE7fMyun5BBnJ611F8zRnkyvIsQ7nl8BCszOcOg4Saw7f7ESoXsMszjfUFD4Nr.VijSKP/yKytVO2Ptl7WIFb/";
      mooziisp = {
        description = "mooziisp";
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$MzkWefhNrnurSwZV$WE7fMyun5BBnJ611F8zRnkyvIsQ7nl8BCszOcOg4Saw7f7ESoXsMszjfUFD4Nr.VijSKP/yKytVO2Ptl7WIFb/";
      };
      ftp = {
        hashedPassword = "$6$qqLx5clVPMJtNVbl$rIt87Xn2Igjr20B3sq3iL61ER8j1WzSa2U3IcG5qpcjAOaObW4o1e3dKEpEwNm8pudL5lKt2/3be4qdUPQ8iY1";
      };
    };
  };

  networking.hostName = "bocft-wsl";

  system.stateVersion = "23.05";
}
