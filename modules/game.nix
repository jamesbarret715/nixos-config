{ pkgs, ... }: {
# Steam with reasonable options
	programs.steam = {
		enable = true;
		package = pkgs.steam.override {
			extraArgs = "-system-composer";
		};

		remotePlay.openFirewall = true;
		gamescopeSession.enable = true;
		extraCompatPackages = [ pkgs.proton-ge-bin ];
	};

# Run games with improved performance
	programs.gamemode.enable = true;

# Useful packages
	environment.systemPackages = with pkgs; [
		mangohud
			wine
			winetricks
	];
}
