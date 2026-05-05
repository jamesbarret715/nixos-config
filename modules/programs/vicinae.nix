{ ... }: {
	flake.modules.homeManager.vicinae = { config, ... }: {
		programs.vicinae.enable = true;

		programs.niri.settings = with config.lib.niri; {
			spawn-at-startup = [ { sh = "vicinae server"; } ];
			binds."Mod+Space".action = actions.spawn "vicinae" "toggle";
		};
	};
}
