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
        isNormalUser = true;
        group = "ftp";
        password = "ftp";
      };
    };
  };

  # Needs to be set explicitly because nixos-wsl disables this for ease of installation
  security.sudo.wheelNeedsPassword = true;

  # Using a purely declarative user setup. This means any future users will have to
  # have a password hash generated with `mkpasswd`
  users.mutableUsers = false;

  networking.hostName = "bocft-wsl";

  system.stateVersion = "23.05";
}
