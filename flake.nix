{
  description = "MoozIiSP's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin/master";
    home.url = "github:nix-community/home-manager";
    #nur.url = "github:nix-community/NUR";
    emacs.url = "github:mooziisp/emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    #deploy-rs.url = "github:serokell/deploy-rs";
    #home.url = github:nix-community/home-manager;

    # Follows
    # TODO what Follows?
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    #home.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";

    misterio77.url = github:misterio77/nix-config;
    nix-colors.url = github:misterio77/nix-colors;
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = { self, darwin, nixpkgs, home, nixos-wsl, ... }@inputs: {
    # The name in ${system}Configurations.${name} should match the hostname
    nixosConfigurations = {
      homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./profiles/machines/homelab/configuration.nix
          # NOTE add overlays
          {
            nixpkgs.overlays = with inputs; [
              emacs.overlay
            ];
          }
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
	  modules = [
	    nixos-wsl.nixosModules.default
            { nixpkgs.overlay = with inputs; [ emacs.overlay ]; }
            ./profiles/machines/wsl
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
        ./profiles/machines/macbook/configuration.nix
        #home.drawinModules.home-manager
        # TODO add overlays
        {
          nixpkgs.overlays = with inputs; [
            nur.overlay
            emacs.overlay
            emacs-overlay.overlay
          ];
        }
        # homebrew
        ./profiles/features/homebrew/darwin.nix
      ];
    };

    overlays = {
      pythonPackages = import ./overlays/python/default.nix;
    };
  };
}
