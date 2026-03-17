{ pkgs, inputs, ... }: {
	imports = [
		./modules/foot.nix
		./modules/librewolf.nix
		./modules/niri.nix
		./modules/nvim.nix
		./modules/stylix.nix

		./modules/packages.nix
	];

	home = {
		username = "james";
		homeDirectory = "/home/james";
		stateVersion = "25.05";
	};

	xdg.enable = true;
 }
