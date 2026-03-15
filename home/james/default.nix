{ pkgs, inputs, dwl-src, ... }: {
	imports = [
		./modules/dwl.nix
		./modules/nvim.nix
		./modules/prismlauncher.nix

		./modules/packages.nix
	];

	home = {
		username = "james";
		homeDirectory = "/home/james";
		stateVersion = "25.05";
	};

	xdg.enable = true;
 }
