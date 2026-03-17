{ config, pkgs, awww, ... }: {
	programs.niri = {
		enable = true;
		settings = {
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

# Replace caps with a ctrl key
				keyboard = {
					xkb.options = "ctrl:nocaps";
				};
			};

# Disable hot corners
			gestures.hot-corners.enable = false;

			layout = {
				gaps = 10;

				focus-ring = {
					width = 2;
					active.color = "#aaaaaa";
					inactive.color = "#444444";
				};
			};

			prefer-no-csd = true;

			window-rules = [
# Open menus as floats
				{
					matches = [ 
						{ app-id = "^menu"; } 
						{ app-id = "^librewolf$"; title = "^Extension"; } 
					]; 
					open-floating = true; 
				}

# Open settings windows as small floats
				{ 
					matches = [ 
						{ app-id = "blueman"; }
					]; 

					open-floating = true; 
					default-window-height.fixed = 800; 
				}
			];

			layer-rules = [
# Show background in overview
				{ matches = [{ namespace = "overview$"; }]; place-within-backdrop = true; }
			];

# Startup apps
			spawn-at-startup = [
				{ command = [ "xwayland-satellite" ]; }
				{ command = [ "waybar" ]; }
				{ command = [ "foot" "--server" ]; }
# Wallpapers
				{ command = [ "awww-daemon" ]; }
				{ command = [ "awww" "img" "/home/james/Pictures/Wallpapers/cityscape.gif" ]; }
				{ command = [ "awww-daemon" "-n" "overview" ]; }
				{ command = [ "awww" "img" "-n" "overview" "/home/james/Pictures/Wallpapers/cityscape-blurred.gif" ]; }
			];

			binds = with config.lib.niri.actions; {
				"Mod+Q" = { action = close-window; repeat = false; };
				"Mod+O".action = toggle-overview;

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
				"Mod+Shift+F".action = fullscreen-window;

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
				modules-right = [ "network" "custom/sep" "backlight" "pulseaudio" "custom/sep" "battery" "custom/sep" "clock" ];

				"niri/workspaces" = {
					format = "{index}";
				};

				"network" = {
					format-wifi = "󰤨 {essid}";
					format-ethernet = "󰈀 {ifname}";
					format-disconnected = "󰤭";
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

# Other programs
	programs.swaylock.enable = true;		# lock screen
	services.mako.enable = true;			# notifications
	services.polkit-gnome.enable = true;	# keyring

	home.packages = with pkgs; [
		awww.packages.${pkgs.stdenv.hostPlatform.system}.default	# wallpaper
		brightnessctl												# brightness
		xwayland-satellite											# X11
	];
}
