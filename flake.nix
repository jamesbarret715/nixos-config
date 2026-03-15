{
	description = "NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

# Nvim nightly version
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

	outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, dwl-src, ... } @ inputs: {
		nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./hosts/carbon/core.nix

				home-manager.nixosModules.home-manager

				{
					nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ];
					
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						sharedModules = [ niri.homeModules.niri ];

						users.james = import ./home/james;
					};
				}
			];
		};
	};
}
