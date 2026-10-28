{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprtasking = {
      url = "github:raybbian/hyprtasking/765575445ce34989575a99f304d0b279e6a980b6";
      inputs.hyprland.follows = "hyprland";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vigiland.url = "github:jappie3/vigiland";

    goal-tracker.url = "github:YaroslavPanasiuk/goal-tracker";

    macro-grid.url = "github:YaroslavPanasiuk/macros-grid-gtk";

    pretested.url = "github:YaroslavPanasiuk/pretested";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      # Systems that can run tests:
      supportedSystems = [ "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
   in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/default/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };

    homeConfigurations.default_user = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
      };
      modules = [
        ./hosts/default/home.nix
      ];
      extraSpecialArgs = { inherit inputs; };
    };

    packages = forAllSystems (system:
      let pkgs = nixpkgsFor.${system};
      in {
        default = self.packages.${system}.install;

        install = pkgs.writeShellApplication {
          name = "install";
          runtimeInputs = with pkgs; [ git ]; # deps
          text = ''${./install.sh} "$@"''; # the script
        };
      });

    apps = forAllSystems (system: {
      default = self.apps.${system}.install;

      install = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    });
  };
}
