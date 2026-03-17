{ pkgs, ... }: {
	stylix = {
		enable = true;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

		opacity.terminal = 0.9;

		fonts = rec {
			monospace = {
				package = pkgs.nerd-fonts.jetbrains-mono;
				name = "JetBrainsMono Nerd Font";
			};

			sansSerif = monospace;
		};

		icons = {
			enable = true;
			package = pkgs.papirus-icon-theme;
			dark = "Papirus-Dark";
			light = "Papirus-Light";
		};

		targets.librewolf = {
			colorTheme.enable = true;
			profileNames = [ "my-profile" ];
		};
	};
}
