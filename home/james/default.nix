{ niri, ... }: {
	imports = [
		./modules/foot.nix
		./modules/librewolf.nix
		./modules/niri.nix
		./modules/nvim.nix
		./modules/stylix.nix
		./modules/vicinae.nix
		./modules/zsh.nix

		./modules/packages.nix
	];

	home = {
		username = "james";
		homeDirectory = "/home/james";
		stateVersion = "25.05";
	};

	nixpkgs.overlays = [ niri.overlays.niri ];
	nixpkgs.config.allowUnfree = true;

	xdg.enable = true;
 }
