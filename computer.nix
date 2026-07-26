{ inputs, pkgs, ... }: {
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

# applications 
	environment.systemPackages = with pkgs; [
		# cli utils
		curl wget
		eza 
		fd
		fzf
		git 
		neovim 
		pciutils usbutils
		ripgrep
		zoxide

		# desktop software
		inputs.helium.packages.${system}.default
		mangohud
		mpv
		spotify
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
}
