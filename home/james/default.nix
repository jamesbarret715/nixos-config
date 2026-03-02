{ pkgs, inputs, dwl-src, ... }: {
	imports = [
		./modules/dwl.nix
		./modules/packages.nix
	];

	home = {
		username = "james";
		homeDirectory = "/home/james";
		stateVersion = "25.05";
	};

	xdg.enable = true;
 }
