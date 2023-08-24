{ config, pkgs, lib, ... }:

{
  services.vsftpd = {
    enable = true;
#   cannot chroot && write
#    chrootlocalUser = true;
    writeEnable = true;
    localUsers = true;
    userlist = [ "ftp" ];
    userlistEnable = true;
  };
  services.vscode-server.enable = true;
}