{ pkgs, dwl-src, ... }: {
# DWL (custom source)
	home.packages = with pkgs; [
		(dwl.overrideAttrs (oldAttrs: {
			src = dwl-src;

			buildInputs = oldAttrs.buildInputs ++ [
			wlroots_0_19
			libdrm
			fcft
			];

			NIX_CFLAGS_COMPILE = "-w";
		}))
	];

# Notifications
	services.fnott = {
		enable = true;
		settings = {
			main = {
				anchor = "top-right";
				stacking-order = "top-down";
				border-size = 2;
				title-font = "JetBrainsMono Nerd Font:size=12";
				summary-font = "JetBrainsMono Nerd Font:size=11";
				body-font = "JetBrainsMono Nerd Font:size=11";
				border-color = "B0B0B0ff";
				background = "111111cc";
				padding-vertical = 12;
				padding-horizontal = 16;
			};
			low = {
				background = "111111cc";
				border-color = "666666ff";
			};
			critical = {
				background = "111111ee";
				border-color = "F38BA8ff";
				default-timeout = 0;
			};
		};
	};
}
