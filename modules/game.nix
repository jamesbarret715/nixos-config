{ pkgs, ... }: {
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		gamescopeSession.enable = false;
		extraCompatPackages = [ pkgs.proton-ge-bin ];
	};

	programs.gamemode.enable = true;

	environment.systemPackages = with pkgs; [
		wine
		winetricks
		mangohud
	];
}
