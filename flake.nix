{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cursor-nixos-flake.url = "github:TudorAndrei/cursor-nixos-flake";

    kwin-effects-forceblur = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, kwin-effects-forceblur, cursor-nixos-flake, claude-code, antigravity, ... }@inputs:
    let
      nixpkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "ventoy-1.1.07"
          "libsoup-2.74.3"
          "ventoy-1.1.10"
          "openssl-1.1.1w"
        ];
      };

      openldapOverlay = final: prev: {
        openldap = prev.openldap.overrideAttrs (old: {
          doCheck = false;
        });
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = nixpkgsConfig;
          overlays = [ openldapOverlay ];
        };
      in {
      }) // {
        nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./modules/packages/flakes.nix
          ];
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig;
            overlays = [ openldapOverlay ];
          };
        };
      };
}
