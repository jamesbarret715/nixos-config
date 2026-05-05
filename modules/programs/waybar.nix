{
	flake.modules.homeManager.waybar = {
		programs.niri.settings.spawn-at-startup = [ { sh = "waybar"; }];

		programs.waybar = {
			enable = true;
			settings = {
				mainBar = {
					layer = "top";
					position = "top";
					height = 24;
					modules-left = [ "niri/workspaces" ];
					modules-right = [ "bluetooth" "network" "custom/sep" "backlight" "pulseaudio" "custom/sep" "battery" "custom/sep" "clock" ];

					"niri/workspaces" = {
						format = "{index}";
					};

					"bluetooth" = {
						format-on = "";
						format-connected = "󰂯 {device_alias}";
					};

					"network" = {
						format-wifi = "󰤨 {essid}";
						format-ethernet = "󰈀 {ifname}";
						format-disconnected = "";
					};

					"backlight" = {
						format = "{icon} {percent}%";
						format-icons = [ "󰃞" "󰃟" "󰃠" ];
					};

					"pulseaudio" = {
						format = "{icon} {volume}%";
						format-muted = "󰝟 muted";
						format-icons = {
							default = [ "󰕿" "󰖀" "󰕾" ];
						};
						on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					};

					"battery" = {
						format = "{icon} {capacity}%";
						format-charging = "󰂄 {capacity}%";
						format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
					};

					"clock" = {
						format = "󰥔 {:%H:%M}";
						tooltip-format = "{:%c}";
					};

					"custom/sep" = {
						format = "|";
						tooltip = false;
					};
				};
			};

			style = ''
				* {
					border: none;
					border-radius: 0;
					padding: 0 4px;
							}

				#workspaces button {
					padding: 0 4px;
				}
			'';
		};
	};
}
