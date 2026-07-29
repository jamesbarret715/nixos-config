{ config, inputs, lib, pkgs, ... }: {
# user 
    users.users.james = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" "video" "audio" "render" ];
    };
    
    programs.zsh.enable = true;

# desktop
    services.displayManager.plasma-login-manager.enable = true;
    services.desktopManager.plasma6.enable = true;

	# NOTE: KWIN_RENDER_NODES has been merged into kwin. as of 6.7.3, it is not available in a release build
	environment.sessionVariables.KWIN_RENDER_NODES = "/dev/dri/renderD128";

# applications 
	environment.systemPackages = with pkgs; [
		# cli utils
		curl wget
		bat eza fd fzf ripgrep zoxide
		file 
		git 
		neovim 
		pciutils usbutils

		# desktop software
		inputs.helium.packages.${stdenv.hostPlatform.system}.default
		mangohud
		mpv
		prismlauncher
		spotify
		zapzap
	];

# gaming
	programs.steam = {
		enable = true;
		package = pkgs.steam.override {
			extraArgs = "-cef-disable-gpu-compositing";
		};

		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		gamescopeSession.enable = true;
	};

	programs.gamescope.enable = true;
	programs.gamemode.enable = true;

# theme
	stylix = {
		enable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

		image = pkgs.fetchurl {
			url = "https://files.catbox.moe/io9ug6.jpeg";
			hash = "sha256-dUt5W5EUXDSr0o2bGxoHlivqPU/1kR5JoDamcKbsAaQ=";
		};

		icons = {
			enable = true;
			package = pkgs.papirus-icon-theme;
			dark = "Papirus-Dark";
			light = "Papirus-Light";
		};

		cursor = { 
			package = pkgs.posy-cursors;
			name = "Posy_Cursor_Black";
			size = 24;
		};
	};

# home manager
	home-manager = {
		useGlobalPkgs = false;
		useUserPackages = false;
		extraSpecialArgs = { inherit inputs; };
		backupFileExtension = "old";
	};

	home-manager.users.james = {
		home = {
			username = "james";
			homeDirectory = "/home/james";
			stateVersion = "26.05";

			pointerCursor = {
				enable = true;
				gtk.enable = true;
			};
		};

		nixpkgs.config.allowUnfree = true;
	};
}
