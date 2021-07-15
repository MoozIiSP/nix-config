{ config, pkgs, ... }:

{
  imports =
    [
      ./common.nix
      # ../services/fail2ban.nix
      # ../services/postfix.nix
    ];

   environment.systemPackages = with pkgs; [
     tmux
     zerotierone
   ];
}