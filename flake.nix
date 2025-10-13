{
  description = "My NixOS flake system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  winboat.url = "github:TibixDev/winboat";
  cursor-nixos-flake.url = "github:TudorAndrei/cursor-nixos-flake";
    
    # Better Blur - using v1.3.6 compatible with Plasma 6.0.0 - 6.3.5
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur/fea9f80f27389aa8a62befb5babf40b28fed328d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, winboat, kwin-effects-forceblur, cursor-nixos-flake, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # optional devShell etc.
      }) // {
        nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./modules/packages/flakes.nix
          ];
        };
      };
}
