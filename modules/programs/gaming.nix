{
	flake.modules.nixos.gaming = { pkgs, ... }: {
		programs.steam = {
			enable = true;
			package = pkgs.steam.override {
				extraArgs = "-cef-disable-gpu-compositing";
			};

			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			# gamescopeSession.enable = true;
		};

		programs.gamemode = {
			enable = true;
			settings = {
				general = {
					# Use P-cores (0-11) for gaming on 12th/13th gen Intel
					# This runs when a game starts
					start = "${pkgs.util-linux}/bin/taskset -pc 0-11 $GAMEMODE_G_PID";
				};
			};
		};

		programs.gamescope = {
			enable = true;
			capSysNice = true;
		};

		environment.systemPackages = with pkgs; [
			mangohud
			protonup-qt
		];
	};
}
