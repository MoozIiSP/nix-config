{ config, ... }:

{
  # english locales
  i18n.defaultLocale = "en_US.UTF-8";

  # german keyboard layout
  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  services.xserver.layout = "us";
#   services.xserver.xkbOptions = "eurosign:e";

  time.timeZone = "Asia/Shanghai";
}