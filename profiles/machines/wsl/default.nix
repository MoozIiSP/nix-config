{pkgs, ...}: {
  imports = [
    ../../common.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "mooziisp";
    startMenuLaunchers = true;
#    nativeSystemd = true;
  };

  users.users.mooziisp = {
    description = "mooziisp";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    password = "1138";
  };

  # Using a purely declarative user setup. This means any future users will have to
  # have a password hash generated with `mkpasswd`
  users.mutableUsers = false;

  # Needs to be set explicitly because nixos-wsl disables this for ease of installation
  security.sudo.wheelNeedsPassword = true;
  users.users.root.password = "1138";

  networking.hostName = "bocft-wsl";

  system.stateVersion = "23.05";
}
