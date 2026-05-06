{ pkgs, ... }: {
	flake.modules.nixos.gaming = { ... }: {
		programs.steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			gamescopeSession.enable = true;
		};

		programs.gamemode = {
			enable = true;
			settings = {
				general = {
					# Use P-cores (0-11) for gaming on 12th/13th gen Intel
					# This runs when a game starts
					start = "${pkgs.util-linux}/bin/taskset -pc 0-11 $GAMEMODE_G_PID";
				};
				custom = {
					start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
					end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
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

		# Force dGPU for Steam via environment if nvidia-offload is available
		# Note: Users can also use 'nvidia-offload steam' or set launch options in steam
		# setting __NV_PRIME_RENDER_OFFLOAD=1 etc globally might be too much, 
		# so we just ensure the tools are there.
	};
}
