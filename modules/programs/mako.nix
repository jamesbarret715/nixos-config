{ ... }: {
	flake.modules.homeManager.mako = { pkgs, ... }: {
		services.mako = {
			enable = true;
			settings = {
				border-radius = 5;
				border-size = 2;
				default-timeout = 5000;
			};
			# stylix will handle the colors and fonts
		};
	};
}
