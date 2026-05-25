{ self, ... }: {
	flake.modules.nixos.desktop = { lib, pkgs, ... }: {
		imports = with self.modules.nixos; [ 
			home-manager 
			niri
			stylix
			nixvim
			thunar
			misc
		];

		boot = {
# shut up the boot process
			initrd.verbose = false;
			consoleLogLevel = 2;
			kernelParams = [
				"quiet"
				"udev.log_level=2"
				"systemd.show_status=auto"
			];

# splash screen
			loader.timeout = 0;
			plymouth = {
				enable = true;
				logo = pkgs.runCommand "empty.png" {} "touch $out";
			};
		};

# my user 
		users.users.james = {
			isNormalUser = true;
			shell = pkgs.zsh;
			extraGroups = [ "wheel" "networkmanager" "video" "audio" "render" ];
		};

		programs.zsh.enable = true;

		home-manager = {
			sharedModules = with self.modules.homeManager; [
				misc
				thunar
				mako
			];
			users.james = {
				home.stateVersion = "26.05";
				imports = with self.modules.homeManager; [
					foot
					helium
					vicinae
					nixvim
					zsh
					mako
				];
			};
		};

		nix.settings.trusted-users = [ "james" ];

		environment.pathsToLink = [
			"/share/applications"
			"/share/xdg-desktop-portal"
		];

# audio 
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			pulse.enable = true;
			wireplumber.enable = true;
		};

# networking
		networking.networkmanager = {
			enable = true;
			wifi.powersave = false;
		};

		hardware.bluetooth = { 
			enable = true;
			powerOnBoot = true;
			settings.Policy.AutoEnable = "true";
		};
		services.blueman.enable = true;

# security
		security = {
			polkit.enable = true;
			sudo.extraConfig = ''
				Defaults timestamp_type=global
				Defaults timestamp_timeout=30
			'';
		};

# system 
		fonts.enableDefaultPackages = true;
		programs.dconf.enable = true;
		services.fwupd.enable = true;

		xdg.portal = {
			enable = true;
			extraPortals = [ 
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-gnome
			];
			config.common.default = [ "gtk" ];
			config.niri.default = [ "gtk" "gnome" ];
		};

		services.dbus = {
			enable = true;
			implementation = lib.mkDefault "broker";
		};
	};

# a laptop is still a "desktop" computer
# with extra bits and bobs like power management:
	flake.modules.nixos.laptop = {
		imports = with self.modules.nixos; [ desktop ];

# enable hibernation and suspend when lid is closed
		boot.resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";
		services.logind.settings.Login.HandleLidSwitch = "suspend";

		services.power-profiles-daemon.enable = true;
		services.upower.enable = true;	
	};
}
