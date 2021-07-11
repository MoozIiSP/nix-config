{ config, lib, ... }:

{
  services.ntp.enable = false;

  services.timesyncd = {
    enable = lib.mkDefault true;
    servers = [
      "cn.pool.ntp.org"
    ];
  };
}
