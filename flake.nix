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

# Nvim nightly
		neovim-nightly-overlay = {
			url = "github:nix-community/neovim-nightly-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Niri window manager
		niri = {
			url = "github:sodiboo/niri-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, awww, neovim-nightly-overlay, niri, ... } @ inputs: {
		nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./hosts/carbon/core.nix

				home-manager.nixosModules.home-manager

				{
					nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ];
					
					home-manager = {
						extraSpecialArgs = { inherit (inputs) awww; };
						sharedModules = [ niri.homeModules.niri ];
						useGlobalPkgs = true;
						useUserPackages = true;

						users.james = import ./home/james;
					};
				}
			];
		};
	};
}
