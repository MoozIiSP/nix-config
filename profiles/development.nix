{ config, pkgs, ... }:

let 
  clangPackages = with pkgs; [
    gcc
    gdb
    # LSP
    clang-tools
    llvmPackages_11.clangUseLLVM
  ];

  jsPackages = with pkgs; [
    nodejs
    nodePackages.npm   # package managerment
  ];

  lispPackages = with pkgs; [
    racket
  ];

  pythonPackages = with pkgs; [
    python39
    python39Packages.pip    # package managerment
    python39Packages.black
    python39Packages.jedi
    # enhance
    python39Packages.rich
    # web
    python39Packages.flask
    python39Packages.django
  ];

  nixosPackages = with pkgs; [
    nixpkgs-review
    nixpkgs-fmt
  ];
in {
  imports = [
    ../services/vscode-server.nix
  ];

  environment.systemPackages = 
    clangPackages ++ 
    jsPackages ++ 
    lispPackages ++ 
    pythonPackages ++
    nixosPackages;

  services.vscode-server.enable = true;
}