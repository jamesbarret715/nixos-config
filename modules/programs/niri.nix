{ inputs, lib, self, ... }: {
	flake-file.inputs.niri = {
		url = "github:sodiboo/niri-flake";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	flake.modules.nixos.niri = { pkgs, ... }: {
		imports = [ inputs.niri.nixosModules.niri ];
		nixpkgs.overlays = [ inputs.niri.overlays.niri ];

		programs.niri = {
			enable = true;
			package = lib.mkForce pkgs.niri-unstable;
		};

		home-manager = {
			users.james.imports = with self.modules.homeManager; [ 
				niri 
				waybar
				hypr
				swaybg
			];
		};

# launch on login
		programs.zsh.interactiveShellInit = ''
			if [[ -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" == 1 ]]; then 
				exec niri-session
			fi
		'';
	};

	flake.modules.homeManager.niri = { config, pkgs, inputs, ... }: {
		home.packages = with pkgs; [
			brightnessctl
			wireplumber
			xwayland-satellite
		];

# niri config
		programs.niri = {
			settings = let 
				colors = config.lib.stylix.colors;
			in {
				hotkey-overlay.skip-at-startup = true;
				prefer-no-csd = true;
				screenshot-path = null;

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

					keyboard.xkb.options = "ctrl:nocaps"; # replace caps with a ctrl key
				};

				layout = {
					gaps = 6;
					focus-ring.enable = false;
					background-color = "transparent";

					border = {
						enable = true;
						width = 2;
						active.color = colors.base05;   # colors: fg
						inactive.color = colors.base02; # colors: bg3
					};
				};

				window-rules = [
					{ # all windows
						clip-to-geometry = true;
						geometry-corner-radius = let radius = 10.0; in {
							top-left = radius; top-right = radius;
							bottom-left = radius; bottom-right = radius;
						};
					}
					{ # chromium pip floats
						matches = [{ title = "^Picture-in-picture$"; }];
						open-floating = true;
					}
					{ # show shared windows as "recording"
						matches = [{ is-window-cast-target = true; }];
						border.active.color = colors.base09; # colors: orange
						border.inactive.color = colors.base08; # colors: red
					}
				];

				layer-rules = [
# show background in overview
					{ matches = [{ namespace = "^wallpaper$"; }]; place-within-backdrop = true; }
				];

				spawn-at-startup = [
					{ command = [ "dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP=niri" ]; }
				];

				binds = with config.lib.niri.actions; {
					"Mod+Q" 	   = { action = close-window; repeat = false; };
					"Mod+O".action = toggle-overview;

# system controls
					"XF86AudioRaiseVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
					"XF86AudioLowerVolume".action  = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
					"XF86AudioMute".action         = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
					"XF86MonBrightnessUp".action   = spawn "brightnessctl" "set" "5%+";
					"XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";

					"Mod+Shift+L" = { action = spawn "loginctl" "lock-session"; allow-when-locked = true; };

# screenshots
					"Mod+Shift+S".action.screenshot       = {};
					"Mod+Ctrl+S".action.screenshot-window = {};
					"Mod+Alt+S".action.screenshot-screen  = { show-pointer = false; };

# focus
					"Mod+H".action = focus-column-left;
					"Mod+J".action = focus-window-down;
					"Mod+K".action = focus-window-up;
					"Mod+L".action = focus-column-right;

					"Mod+WheelScrollDown" = { action = focus-workspace-down; cooldown-ms = 150; };
					"Mod+WheelScrollUp"   = { action = focus-workspace-up;   cooldown-ms = 150; };

# move
					"Mod+Ctrl+H".action = move-column-left;
					"Mod+Ctrl+J".action = move-window-down;
					"Mod+Ctrl+K".action = move-window-up;
					"Mod+Ctrl+L".action = move-column-right;

# sizing
					"Mod+R".action       = switch-preset-column-width;
					"Mod+Shift+R".action = switch-preset-window-height;
					"Mod+Ctrl+R".action  = reset-window-height;
					"Mod+F".action       = maximize-column;
					"Mod+Shift+F".action = fullscreen-window;
					"Mod+X".action 	     = expand-column-to-available-width;

# workspaces to numkeys
				} // (builtins.foldl' (a: b: a // b) {} (builtins.genList (i:
					let n = toString (i + 1); in { "Mod+${n}".action = focus-workspace (i + 1); }
				) 9));
			};
		};
	};
}
