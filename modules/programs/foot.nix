{ self, ... }: {
	flake.modules.homeManager.foot = { config, ... }: {
		programs.foot = { 
			enable = true;
			settings.main.pad = "10x10 center";
		};
	
		programs.niri.settings = with config.lib.niri; {
			spawn-at-startup = [ { sh = "foot --server"; } ];
			binds."Mod+Return".action = actions.spawn "footclient";
		};
	};
}
