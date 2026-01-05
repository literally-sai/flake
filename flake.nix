{
  description = "literally-sai's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-parts.url = "github:hercules-ci/flake-parts";
    vermvim = {
      url = "github:literally-sai/vermvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, pkgs, ... }:
        {
          packages.vermvim = inputs.vermvim.packages.${system}.default;
        };

      flake =
        let
          baseSpecialArgs = { inherit inputs; };

          mkPkgs =
            system:
            import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                inputs.rust-overlay.overlays.default
                (final: prev: {
                  nur = import inputs.nur {
                    pkgs = final;
                    nurpkgs = final;
                  };
                })
              ];
            };

          commonNixosModules = [
            inputs.disko.nixosModules.disko
            inputs.hyprland.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            ./hosts/common
            ./modules
          ];

          commonHomeModules = [
            inputs.hyprland.homeManagerModules.default
            inputs.spicetify.homeManagerModules.default
            ./home/home.nix
          ];

          hosts = [
            "Ghylak"
            "Murgo"
          ];

          mkNixos =
            hostName:
            inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              pkgs = mkPkgs "x86_64-linux";
              specialArgs = baseSpecialArgs // {
                inherit hostName;
              };
              modules = commonNixosModules;
            };

          mkHome =
            hostName:
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = mkPkgs "x86_64-linux";
              extraSpecialArgs = baseSpecialArgs // {
                inherit hostName;
                inherit (inputs) self;
              };
              modules = commonHomeModules;
            };

        in
        {
          nixosConfigurations = builtins.listToAttrs (
            map (host: {
              name = host;
              value = mkNixos host;
            }) hosts
          );

          homeConfigurations = builtins.listToAttrs (
            map (host: {
              name = host;
              value = mkHome host;
            }) hosts
          );
        };
    };
}
