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
        in
        {
          nixosConfigurations = {
            Ghylak = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              pkgs = mkPkgs "x86_64-linux";
              specialArgs = baseSpecialArgs // {
                hostName = "Ghylak";
              };
              modules = [
                inputs.disko.nixosModules.disko
                inputs.hyprland.nixosModules.default
                inputs.sops-nix.nixosModules.sops
                ./hosts/common
                ./hosts/ghylak
                ./modules
              ];
            };
            Murgo = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              pkgs = mkPkgs "x86_64-linux";
              specialArgs = baseSpecialArgs // {
                hostName = "Murgo";
              };
              modules = [
                inputs.disko.nixosModules.disko
                inputs.hyprland.nixosModules.default
                ./hosts/common
                ./hosts/murgo
                ./modules
              ];
            };
          };
          homeConfigurations = {
            "Ghylak" = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = mkPkgs "x86_64-linux";
              extraSpecialArgs = baseSpecialArgs // {
                hostName = "Ghylak";
                inherit (inputs) self;
              };
              modules = [
                inputs.hyprland.homeManagerModules.default
                inputs.spicetify.homeManagerModules.default
                ./home/home.nix
              ];
            };
            "Murgo" = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = mkPkgs "x86_64-linux";
              extraSpecialArgs = baseSpecialArgs // {
                hostName = "Murgo";
                inherit (inputs) self;
              };
              modules = [
                inputs.hyprland.homeManagerModules.default
                inputs.spicetify.homeManagerModules.default
                ./home/home.nix
              ];
            };
          };
        };
    };
}
