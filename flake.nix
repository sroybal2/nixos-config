{
  description = "NixOS — GNOME + Niri, Catppuccin Mocha via Stylix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, mango, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        stylix.nixosModules.stylix
        mango.nixosModules.mango
        { programs.mango.enable = true; }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.steve = {
              imports = [
                ./home.nix
                mango.hmModules.mango
                ({ ... }: {
                  wayland.windowManager.mango.enable = true;
                  # Config managed externally via ~/.config/mango (cloned from DreamMaoMao/mango-config)
                })
              ];
            };
          };
        }
      ];
    };
  };
}
