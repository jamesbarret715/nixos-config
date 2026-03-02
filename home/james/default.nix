{ pkgs, inputs, dwl-src, scripts-src, ... }: {
	imports = [
		./modules/dwl.nix
		./modules/fish.nix
		./modules/foot.nix
		./modules/nvim.nix
		./modules/launcher.nix
		./modules/packages.nix
	];

	home = {
		username = "james";
		homeDirectory = "/home/james";
		stateVersion = "25.05";
	};

# SSH keys via sops
	sops.secrets."ssh/private_key" = {
		path = "/home/james/.ssh/id_ed25519";
		mode = "0600";
	};

	xdg.enable = true;
 }
