{ lib, pkgs, inputs, ... }: {
	imports = [
		./hardware-configuration.nix
		./nvidia.nix

		../../modules/bluetooth.nix
		../../modules/pipewire.nix
		../../modules/virtualisation.nix
		../../modules/game.nix
	];

	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
# CachyOS kernel with BORE scheduler
# kernelPackages = pkgs.linuxPackages_cachyos;
# Kernel parameters for Nvidia + Intel hybrid
		kernelParams = [ "i915.force_probe=7d55" "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
		initrd.kernelModules = [ "i915" ];
	};

	networking = {
		hostName = "carbon";
		networkmanager.enable = true;
	};

	fileSystems = {
		"/".device = lib.mkForce "/dev/disk/by-partlabel/disk-main-root";
		"/boot".device = lib.mkForce "/dev/disk/by-partlabel/disk-main-ESP";
	};

	time.timeZone = "Europe/London";
	i18n.defaultLocale = "en_GB.UTF-8";

# Nix settings
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store = true;
		substituters = [
			"https://cache.nixos.org"
			"https://nyx.chaotic.cx"
			"https://nix-gaming.cachix.org"
			"https://cuda-maintainers.cachix.org"
		];
		trusted-public-keys = [
			"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
			"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
			"chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
			"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
			"cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
		];
	};

# Selective -O3 / -march=native via overlay (kernel + stdenv)
# Applied only to packages that benefit — not globally to avoid cache misses
	nixpkgs.overlays = [
		(final: prev: {
# Optimised stdenv for manual use in specific packages
			 optimisedStdenv = prev.stdenv.override {
				 cc = prev.stdenv.cc.override {
					 extraBuildFlags = [ "-O3" "-march=native" "-mtune=native" ];
				 };
			 };
		 })
	];

	nixpkgs.config.allowUnfree = true;

	users.users.james = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "video" "input" "render" ];
		shell = pkgs.fish;
	};

	environment.systemPackages = with pkgs; [
		git vim curl wget
		pciutils usbutils
		brightnessctl
		sops age
	];

	programs.fish.enable = true;
	programs.dconf.enable = true;   # needed for virt-manager

# XDG portals for Wayland
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
		config.common.default = "wlr";
	};

	services = {
		udev.packages = [ pkgs.libinput ];
		logind.lidSwitch = "suspend";
		fwupd.enable = true;
		upower.enable = true;
		gnome.gnome-keyring.enable = true;
	};

	security = {
		rtkit.enable = true;
		polkit.enable = true;
		pam.services.login.enableGnomeKeyring = true;
	};

	system.stateVersion = "25.05";
}
