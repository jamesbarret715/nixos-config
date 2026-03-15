{ lib, pkgs, inputs, ... }: {
	imports = [
		./hardware-configuration.nix
		./nvidia.nix

		../../modules/bluetooth.nix 
		../../modules/game.nix # Options/packages useful for gaming
		../../modules/howdy.nix # Windows Hello facial recognition
		../../modules/greetd.nix
		../../modules/network.nix 
		../../modules/pipewire.nix 
		../../modules/plymouth.nix # Splash screen at boot
		../../modules/virtualisation.nix # Options/packages useful for QEMU/KVM virtualisation
	];

	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;

		kernelPackages = pkgs.linuxPackages_zen; # zen kernel uses BORE scheduler
		kernelParams = [ "i915.force_probe=7d55" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
		initrd.kernelModules = [ "i915" ];

		consoleLogLevel = 2;
		resumeDevice = lib.mkForce "/dev/disk/by-partlabel/disk-main-swap";
	};

# Battery & power management
	powerManagement = {
		enable = true;
		powertop.enable = true;
		cpuFreqGovernor = "ondemand";
	};

	services.tlp = {
		enable = true;
		settings = {
			CPU_BOOST_ON_BAT = 0;
		};
	};

# Manually specify filesystem locations based on partition label
	fileSystems = {
		"/".device = lib.mkForce "/dev/disk/by-partlabel/disk-main-root";
		"/boot".device = lib.mkForce "/dev/disk/by-partlabel/disk-main-ESP";
	};

# Basic system settings
	networking.hostName = "carbon";
	time.timeZone = "Europe/London";
	i18n.defaultLocale = "en_GB.UTF-8";

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
		substituters = [
			"https://cache.nixos.org"
			"https://niri.cachix.org"
			"https://nix-gaming.cachix.org"
			"https://cuda-maintainers.cachix.org"
		];
		trusted-public-keys = [
			"niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
			"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
			"cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
		];
	};

	nixpkgs.config.allowUnfree = true;

	users.users.james = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "video" "input" "render" ];
		shell = pkgs.fish;
	};

	environment.systemPackages = with pkgs; [
		git vim curl wget
		pciutils usbutils
	];

	programs.fish.enable = true;
	programs.dconf.enable = true; # needed for virt-manager

# XDG portals for Wayland
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
		config.common.default = "wlr";
	};

	services = {
		udev.packages = [ pkgs.libinput ];
		logind.settings.Login.HandleLidSwitch = "suspend";
		fwupd.enable = true;
		upower.enable = true;
		gnome.gnome-keyring.enable = true;
		dbus.implementation = "broker";
	};

	security = {
		rtkit.enable = true;
		polkit.enable = true;
		pam.services.login.enableGnomeKeyring = true;
	};

	system.stateVersion = "25.05";
}
