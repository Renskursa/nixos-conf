{
  description = "My NixOS flake system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    winboat.url = "github:TibixDev/winboat";
    # Use v1.3.6 for Plasma 6.0.0 - 6.3.5 (you have 6.2.2)
    kwin-effects-forceblur.url = "github:taj-ny/kwin-effects-forceblur/fea9f80f27389aa8a62befb5babf40b28fed328d";
  };

  outputs = { self, nixpkgs, flake-utils, winboat, kwin-effects-forceblur, ... }@inputs:
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
