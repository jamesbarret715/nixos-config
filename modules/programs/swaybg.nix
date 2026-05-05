{ ... }: {
	flake.modules.homeManager.swaybg = { pkgs, ... }: let
		wallpaper = pkgs.fetchurl {
			url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/main/nature/mist_forest_1.png";
			sha256 = "17b1q72ds17mz4pgs1dwqy8spdlkssshdhj00hdprwsl815rssxl";
		};
	in {
		home.packages = [ pkgs.swaybg ];

		programs.niri.settings.spawn-at-startup = [
			{ sh = "swaybg -i ${wallpaper} -m fill"; }
		];
	};
}
