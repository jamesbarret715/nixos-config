{ pkgs, ... }: {
# Steam with reasonable options
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		gamescopeSession.enable = false;
		extraCompatPackages = [ pkgs.proton-ge-bin ];
	};

# Run games with improved performance
	programs.gamemode.enable = true;

# Useful packages
	environment.systemPackages = with pkgs; [
		wine
		winetricks
		mangohud
	];
}
