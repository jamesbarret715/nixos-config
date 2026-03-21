{
	description = "NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# AWWW wayland wallpapers 
		awww = {
			url = "git+https://codeberg.org/LGFae/awww";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Firefox extensions
		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Stylix theming 
		stylix = {
			url = "github:nix-community/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Nixvim neovim with nix
		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Niri window manager
		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, awww, firefox-addons, stylix, nixvim, niri, ... } @ inputs: {
		nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./hosts/carbon/core.nix

				home-manager.nixosModules.home-manager

				{
					home-manager = {
						extraSpecialArgs = { inherit (inputs) awww firefox-addons niri; };
						sharedModules = [ 
							niri.homeModules.niri
							stylix.homeModules.stylix 
							nixvim.homeModules.nixvim
						];

						useUserPackages = true;
						backupFileExtension = "bak";

						users.james = import ./home/james;
					};
				}
			];
		};
	};
}
