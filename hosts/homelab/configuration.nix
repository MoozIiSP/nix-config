# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:

let
  lang = "us";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../../profiles/features/hardware
      ../../../profiles/features/system-side/dummy-desktop.nix
      ../../../profiles/virtualization.nix
      ../../../profiles/features/system-side/default.nix
      # ../../../profiles/research.nix
      ../../../profiles/common.nix
    ];

  # NOTE Nix configuration
  nixpkgs.config.allowUnfree = true;

  # NOTE bootloader configuration
  boot = {
    loader = {
      grub = {
        enable = true;
        #version = 2;
        #memtest86.enable = true;
        #timeout = 2;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };

  # NOTE Network
  networking = {
    hostName = "HomeLab"; # Define your hostname.
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" "114.114.114.114" ];

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # NOTE localization
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # nixpkgs.config.allowUnfree = true;


  # NOTE NO Printer
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # NOTE Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mooziisp = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    # shell = pkgs.zsh;  TODO: first use bash
  };
  #users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ secrets.mooziisp ];

  # NOTE fontconfig
    fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      fira-mono
      libertine
      open-sans
      twemoji-color-font
      liberation_ttf
      sarasa-gothic
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # NOTE List services that you want to enable:
  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      permitRootLogin = "yes";
      passwordAuthentication = true;
    };

    sshd.enable = true;

    # discover services on other systems
    avahi = {
      enable = true;
      nssmdns = true;
      # server
      publish = {
        enable = true;
        addresses = true;
        domain = true;
      };
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;

    resolved = {
      enable = true;
      domains = [ "lan" ];
      # TODO workaround for https://github.com/NixOS/nixpkgs/issues/66451
      dnssec = "false";
    };

    # time sync
    ntp.enable = true;
    timesyncd = {
      enable = true;
      servers = [
        "cn.pool.ntp.org"
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Nix daemon config
  nix = {
    # Automate `nix-store --optimise`
    autoOptimiseStore = true;

    # Automate garbage collection
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    # Avoid unwanted garbage collection when using nix-direnv
    extraOptions = ''
      keep-outputs     = true
      keep-derivations = true
    '';

    # Required by Cachix to be used as non-root user
    trustedUsers = [ "root" "mooziisp" ];

    #useSandbox = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
