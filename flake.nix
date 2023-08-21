{
  description = "MoozIiSP's system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    emacs-darwin.url = "github:mooziisp/emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    #deploy-rs.url = "github:serokell/deploy-rs";
    #home.url = github:nix-community/home-manager;

    # Follows
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    #home.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";

    #misterio77.url = github:misterio77/nix-config;
    #nix-colors.url = github:misterio77/nix-colors;
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = { self, darwin, nixpkgs, nixos-wsl, ... }@inputs: {
    # The name in ${system}Configurations.${name} should match the hostname
    nixosConfigurations = {
      homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/homelab/configuration.nix
          # NOTE add overlays
          {
            nixpkgs.overlays = with inputs; [
              emacs-darwin.overlay
            ];
          }
        ];
      };

      # build installer via 'nix build .#nixosConfigurations.wsl.config.'
      wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            nixpkgs.overlays = with inputs; [
              emacs-overlay.overlay
            ];
          }
          ./host/wsl
        ];
        specialArgs = { inherit inputs; };
      };
    };

    nixpkgsConfigurations = {
      rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
      };
    };

    darwinConfigurations."ZhongdeMBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/darwin/configuration.nix
        #home.drawinModules.home-manager
        # TODO add overlays
        {
          nixpkgs.overlays = with inputs; [
            nur.overlay
            emacs-darwin.overlay
            emacs-overlay.overlay
          ];
        }
        # homebrew
        ./hosts/darwin/homebrew.nix
      ];
    };

    overlays = {
      pythonPackages = import ./overlays/python/default.nix;
    };
  };
}
