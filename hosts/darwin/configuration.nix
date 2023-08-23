{ config, pkgs, ... }:

{
  # No Deep Learning Environment
  # python-overlay = (import ../../overlays/python/default.nix).machine-learning-bundle;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Nix Build Configuration
  nix.maxJobs = "auto";
  nix.buildCores = 0;

  nix.trustedUsers = [ "root" "mooziisp" ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  #nix.package = pkgs.nixUnstable;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.overlays = {
    pythonPackages = import ../../../overlays/python/default.nix;
  };
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Nix Caches
  nix.binaryCaches = [
    # Personal cahce using Github Action to build.
    "https://cachix.org/api/v1/cache/mooziisp"
    # Nightly Emacs build cache for github.com/cmacrae/emacs
    "https://cachix.org/api/v1/cache/nix-community"
  ];
  nix.binaryCachePublicKeys = [
    "mooziisp.cachix.org-1:5vehr68MwH/1UWMyX2JYj7c5DprKDT2Mt8ER3qarMzU="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.trustedBinaryCaches = config.nix.binaryCaches;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ #vim
      emacs
      git
      zile
      python3
      #clang_12 FIXME this is collison with gcc
      gcc
      jdk
      smartmontools
      # base build
      gnumake
      cups
      cmake
      bzip2
      libpng
      zlib
      ccache

      torchmetric
    ];

  environment.variables = {
    "EDITOR" = "zile";
    "VISUAL" = "zile";
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = false;
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
}
