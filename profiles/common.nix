{ config, pkgs, lib, ... }:

{
  imports = [
    ../services/grub.nix
    ../services/ssh.nix
    ../services/ntp.nix
    ../services/dns.nix
    ../services/nix.nix
    ../services/localization.nix
  ];

  # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    # system status monitor
    htop
    iotop  # A tool to find out the processes doing the most IO
    iftop  # Display bandwidth usage on a network interface
    inotify-tools  # modification monitor
    # network tools
    tcpdump
    telnet
    whois  # Intelligent WHOIS client from Debian
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
    gitAndTools.gitFull  # version control
  ];

  programs.bash.enableCompletion = true;

  environment.variables = {
    "EDITOR" = "zile";
    "VISUAL" = "zile";
  };

  # documentation.enable = false;
  # documentation.nixos.enable = false;
  # #documentation.man.enable = false;
  # documentation.info.enable = false;
  # documentation.doc.enable = false;

  system.copySystemConfiguration = true;
}