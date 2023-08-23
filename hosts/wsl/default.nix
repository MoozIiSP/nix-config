{ pkgs, ... }:

{
  imports = [
    ../common.nix
    ./bocft-dev.nix
  ];

  wsl = {
    enable = true;
    #wslConf.automount.root = "/mnt";
    automountPath = "/mnt";
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
      root.password = "1138";
      mooziisp = {
        description = "mooziisp";
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [ "wheel" ];
        password = "1138";
      };
    };
  };

  networking.hostName = "bocft-wsl";

  system.stateVersion = "23.05";
}
