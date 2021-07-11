{ config, pkgs, lib, ... }:

{
#   imports = [
#     # TODO
#     ../users/davidak/personal.nix
#   ];

  # install packages
  environment.systemPackages = with pkgs; [
    virtmanager
  ];

  # container virtualization
  virtualisation.docker.enable = true;

  # hypervisor virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
  };
}