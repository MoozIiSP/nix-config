{
  description = "PyTorch Binary for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, emacs-src, emacs-vterm-src }:
    let
      pkgs = import nixpkgs {
        config = { };
        system = "aarch64-darwin";
      };
    in with pkgs; {
      packages.aarch64-darwin = pkgs.extend self.overlay;

      overlay = final: prev: {
        pytorch = import ./bin.nix;
      };
    };
}
