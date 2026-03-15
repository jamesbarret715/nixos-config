{ pkgs, ... }: {
	services.greetd = {
		enable = true;
		useTextGreeter = true;

		settings = {
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --sessions ${pkgs.niri}/share/wayland-sessions";
				user = "greeter";
			};
		};
	};

	services.displayManager.sessionPackages = [ pkgs.niri ];
}
