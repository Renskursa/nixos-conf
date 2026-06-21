{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cursor-nixos-flake = {
      url = "github:TudorAndrei/cursor-nixos-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, plasma-manager, kwin-effects-forceblur, cursor-nixos-flake, claude-code, antigravity, ... }@inputs:
    let
      nixpkgsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "ventoy-1.1.12"
          "electron-39.8.10"
        ];
      };

      openldapOverlay = final: prev: {
        openldap = prev.openldap.overrideAttrs (old: {
          doCheck = false;
        });
      };
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-bak";
            # Overwrite a stale *.hm-bak instead of aborting activation. Some
            # apps (e.g. GTK2 rewriting ~/.gtkrc-2.0) recreate managed files as
            # real files, so HM re-backs-them-up on every rebuild and otherwise
            # collides with the previous backup.
            home-manager.overwriteBackup = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              plasma-manager.homeModules.plasma-manager
            ];
            home-manager.users.renskursa = import ./home/renskursa;
          }
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
