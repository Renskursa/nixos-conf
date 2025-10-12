{
  description = "My NixOS flake system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    winboat.url = "github:TibixDev/winboat";
  };

  outputs = { self, nixpkgs, flake-utils, winboat, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        # optional devShell etc.
      }) // {
        nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            {
              environment.systemPackages = [
                winboat.packages.x86_64-linux.winboat
              ];
            }
          ];
        };
      };
}
