{ config, pkgs, ... }: {
	programs.niri = {
		enable = true;
		settings = {
# Config
			input = {
				touchpad = {
					natural-scroll = true;
					tap = true;
					accel-speed = 0.0;
					accel-profile = "adaptive";
					scroll-method = "two-finger";
					click-method = "button-areas";
				};

				mouse = {
					natural-scroll = false;
					accel-speed = -0.5;
				};

				focus-follows-mouse = {
					enable = true;
					max-scroll-amount = "40%";
				};

				keyboard = {
					xkb.options = "ctrl:nocaps";
				};
			};

			layout = {
				gaps = 10;

				focus-ring = {
					width = 2;
					active.color = "#aaaaaa";
					inactive.color = "#444444";
				};
			};

			prefer-no-csd = true;

# Window rules
			window-rules = [
				{ matches = [{ app-id = "menu"; }]; open-floating = true; }
			];

# Startup apps
			spawn-at-startup = [
				{ command = [ "waybar" ]; }
				{ command = [ "swaybg" "-i" "~/.wallpaper" ]; }
				{ command = [ "foot" "--server" ]; }
			];

			binds = with config.lib.niri.actions; {
				"Mod+Q" = { action = close-window; repeat = false; };

# Apps
				"Mod+Return".action       = spawn "footclient";
				"Mod+Shift+Return".action = spawn "librewolf";
				"Mod+Space".action        = spawn "/home/james/.scripts/launcher";

# System controls
				"XF86AudioRaiseVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
				"XF86AudioLowerVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
				"XF86AudioMute".action         = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
				"XF86MonBrightnessUp".action   = spawn "brightnessctl" "set" "5%+";
				"XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";

# Screenshots
				"Mod+Shift+S".action = spawn "grim -s $(slurp)";

# Focus
				"Mod+H".action = focus-column-left;
				"Mod+J".action = focus-window-down;
				"Mod+K".action = focus-window-up;
				"Mod+L".action = focus-column-right;

# Move
				"Mod+Ctrl+H".action = move-column-left;
				"Mod+Ctrl+J".action = move-window-down;
				"Mod+Ctrl+K".action = move-window-up;
				"Mod+Ctrl+L".action = move-column-right;

# Sizing
				"Mod+R".action       = switch-preset-column-width;
				"Mod+Shift+R".action = switch-preset-window-height;
				"Mod+Ctrl+R".action  = reset-window-height;
				"Mod+F".action       = maximize-column;

# Workspaces to numkeys
			} // (builtins.foldl' (a: b: a // b) {} (builtins.genList (i:
				let n = toString (i + 1); in {
					"Mod+${n}".action = focus-workspace (i + 1);
				}
			) 9));

			outputs."eDP-1" = {
				scale = 1.5;
			};
		};
	};

# Status bar
	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				layer = "top";
				position = "top";
				height = 24;
				modules-left = [ "niri/workspaces" ];
				modules-right = [ "network" "custom/sep" "battery" "custom/sep" "clock" ];

				"niri/workspaces" = {
					format = "{index}";
				};

				"network" = {
					format-wifi = "󰤨 {essid}";
					format-ethernet = "󰈀 {ifname}";
					format-disconnected = "󰤭";
				};

				"battery" = {
					format = "{icon} {capacity}%";
					format-charging = "󰂄 {capacity}%";
					format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
				};

				"clock" = {
					format = "󰥔 {:%H:%M}";
				};

				"custom/sep" = {
					format = "|";
					tooltip = false;
				};
			};
		};

		style = ''
* {
	font-family: JetBrainsMono Nerd Font;
	font-size: 14px;
	border: none;
	border-radius: 0;
	padding: 0 4px;
}

window#waybar {
	background: rgba(38, 38, 38, 0.8);
	color: #eeeeee;
}

#workspaces button {
	color: #bbbbbb;
	padding: 0 4px;
}

#workspaces button.active {
	color: #ffffff;
}
		'';
	};

# Other programs
	programs.swaylock.enable = true;		# lock screen
	services.mako.enable = true;			# notifications
	services.polkit-gnome.enable = true;    # keyring

	home.packages = with pkgs; [
		swaybg			# wallpaper

		grim 			# screenshots
		slurp
	
		brightnessctl	# brightness
	];
}
