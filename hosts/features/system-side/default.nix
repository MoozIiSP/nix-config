{ config, lib, pkgs, ... }:
with pkgs;
{
  # all profiles must have basic bundle
  systemEnhancedPackages = with pkgs; [
    # hardware info
    smartmontools
    # download management
    # compression
    # system tools
    #rsync
    htop
    aria2c
  ];

  # should use shell.nix to manage third library
  systemDevelPackages = {
    cc = {
      common = [
        cmake cmake-language-server
        # LSP
        clang-tools clang ];
      gcc = [ gcc gdb ];
    };

    js = {
      common = [ nodejs nodePackages.npm ];
    };

    lisp = {
      common = [ racket ];
    };

    python = with python3Packages; {
      common = [ python3 ];
      web = [ flask django ];
      ai = [ pytorch-bin ];
      utils = [ rich ];
    };
  };

  # backupSystemPackages = with pkgs; [

  # ];

  remoteManagePackages = with pkgs; [
    # backgroud process
    tmux
    # Clusters
    zertierone
    tailscale
  ];
}
