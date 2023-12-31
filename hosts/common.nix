{ config, pkgs, lib, inputs, ... }:

{
  #imports = [
    # ../services/grub.nix
    # ../services/ssh.nix
    # ../services/ntp.nix
    # ../services/dns.nix
    # ../services/nix.nix
    # ../services/localization.nix
  #];

  # mount tmpfs on /tmp
  #boot.tmpOnTmpfs = lib.mkDefault true;

  # FIXME Emacs 28.0.50
  # services.emacs.enable = true;
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  #   # (import ../overlays)  # just fix version
  # ];

  services.emacs.enable = true;
  services.emacs.package = with pkgs; ((emacsPackagesFor pkgs.emacs-git).emacsWithPackages (epkgs: [ epkgs.vterm ]));

  environment.systemPackages = with pkgs; [
    # system status monitor
    htop
    iotop  # A tool to find out the processes doing the most IO
    iftop  # Display bandwidth usage on a network interface
    inotify-tools  # modification monitor
    # network tools
    tcpdump
    inetutils
    # whois  # Intelligent WHOIS client from Debian
    lsof
    # download
    wget
    curl
    # program debugger
    strace
    # compression
    xz
    lz4
    zip
    unzip
    # system tool
    rsync
    file  # A program that shows the type of files
    restic  # A backup program that is fast, efficient and secure
    xclip  # Tool to access the X clipboard from a console application
    tealdeer  # A very fast implementation of tldr in Rust
    dfc  # advanced df
    ranger  # cli file explorer
    gitAndTools.gitFull  # version control
    # editor
    zile
    ((emacsPackagesFor emacs-git).emacsWithPackages (epkgs: [ epkgs.rime ]))
    vsftpd
    nodejs
    jdk
    python3
    # cachix
    #cachix
  ];
  programs.fish.enable = true;
  #programs.bash.enableCompletion = true;

  environment.variables = {
    "EDITOR" = "emacs";
    "VISUAL" = "emacs";
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  time.timeZone = "Asia/Shanghai";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  # documentation.enable = false;
  # documentation.nixos.enable = false;
  # #documentation.man.enable = false;
  # documentation.info.enable = false;
  # documentation.doc.enable = false;
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
#    "home-manager=${inputs.home-manager}"
  ];
  #system.copySystemConfiguration = true;

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      fira-mono
      libertine
      open-sans
      twemoji-color-font
      liberation_ttf
      sarasa-gothic
      maple-mono-SC-NF
    ];

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
