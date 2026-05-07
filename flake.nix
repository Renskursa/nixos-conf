{
  description = "My NixOS flake system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cursor-nixos-flake.url = "github:TudorAndrei/cursor-nixos-flake";
    
    # Better Blur - using v1.3.6 compatible with Plasma 6.0.0 - 6.3.5
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur/fea9f80f27389aa8a62befb5babf40b28fed328d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = { self, nixpkgs, flake-utils, kwin-effects-forceblur, cursor-nixos-flake, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "ventoy-1.1.07"
              "libsoup-2.74.3"
              "ventoy-1.1.10"
            ];
          };
        };
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
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "ventoy-1.1.07"
                "libsoup-2.74.3"
                "ventoy-1.1.10"
              ];
            };
          };
        };
      };
}
