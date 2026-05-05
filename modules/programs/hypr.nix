{ ... }: {
	flake.modules.homeManager.hypr = { lib, pkgs, ... }: {
		programs.hyprlock = {
			enable = true;
			settings = {
				background = lib.mkForce {
					path = "screenshot";
					blur_size = 8;
					blur_passes = 2;
					brightness = 0.8;
				};
			};
		};

		services.hypridle = {
			enable = true;
			settings = {
				general = {
					lock_cmd = "pidof hyprlock || hyprlock";
					before_sleep_cmd = "loginctl lock-session";
					after_sleep_cmd = "niri msg action power-on-monitors";
				};

				listener = [
					{
						timeout = 300; # 5min
						on-timeout = "loginctl lock-session";
					}
					{
						timeout = 330; # 5.5min
						on-timeout = "niri msg action power-off-monitors";
						on-resume = "niri msg action power-on-monitors";
					}
				];
			};
		};

		home.packages = [ pkgs.hyprpolkitagent ];

		programs.niri.settings.spawn-at-startup = [
			{ sh = "hyprpolkitagent"; }
		];
	};
}
