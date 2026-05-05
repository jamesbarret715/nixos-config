{ inputs, ... }: {
	flake-file.inputs.helium = {
		url = "github:AlvaroParker/helium-nix";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	flake.modules.homeManager.helium = { config, inputs, pkgs, ... }: {
		home.packages = with pkgs.stdenv.hostPlatform; [
			inputs.helium.packages.${system}.default
		];

		programs.niri.settings = with config.lib.niri; {
			binds."Mod+W".action = actions.spawn "helium";
		};
	};
}
