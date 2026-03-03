{
	description = "NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		neovim-nightly-overlay = {
			url = "github:nix-community/neovim-nightly-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# CachyOS kernel + optimised packages
		chaotic = {
			url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# My custom software
		dwl-src = {
			url = "github:jamesbarret715/dwl";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, chaotic, dwl-src, ... }@inputs: {
		nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs dwl-src; };
			modules = [
				./hosts/carbon/core.nix

				chaotic.nixosModules.default
				home-manager.nixosModules.home-manager

				{
					nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ];

					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { inherit inputs dwl-src; };
					home-manager.users.james = import ./home/james;
				}
			];
		};
	};
}
