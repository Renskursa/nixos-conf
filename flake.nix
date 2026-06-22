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

    klassy-src = {
      url = "github:paulmcauley/klassy";
      flake = false;
    };

    arctis-chatmix-src = {
      url = "github:awth13/Linux-Arctis-7-Plus-ChatMix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, stylix, home-manager, plasma-manager, kwin-effects-forceblur, cursor-nixos-flake, claude-code, antigravity, ... }@inputs:
    let
      usernames = [ "renskursa" ];

      nixpkgsConfig = {
        allowUnfree = true;
        allowInsecurePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "ventoy"
          "electron"
        ];
      };

      # openldap tests are flaky and time out on some systems
      openldapOverlay = final: prev: {
        openldap = prev.openldap.overrideAttrs (old: {
          doCheck = false;
        });
      };
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs usernames; };
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
            home-manager.users = builtins.listToAttrs (map (name: {
              name = name;
              value = {
                imports = [ ./home ];
                home.username = name;
                home.homeDirectory = "/home/${name}";
              };
            }) usernames);
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
