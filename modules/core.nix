{ ... }: {
	flake.modules.nixos.core = { lib, pkgs, ... }: {

# boot
		boot.loader = {
			systemd-boot.enable = lib.mkDefault true;
			efi.canTouchEfiVariables = true;
		};

# filesystems
		fileSystems = lib.mkDefault {
			"/" = { device = "/dev/disk/by-partlabel/disk-main-root"; fsType = "ext4"; };
			"/boot" = { device = "/dev/disk/by-partlabel/disk-main-ESP"; fsType = "auto"; };
		};

# time & locale
		time.timeZone = "Europe/London";
		i18n.defaultLocale = "en_GB.UTF-8";

# nix
		system.stateVersion = lib.mkDefault "26.05";

		nix.settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;
			substituters = [ "https://cache.nixos.org" ];
		};

		nix.gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 1d";
		};

# nixpkgs 
		nixpkgs.config.allowUnfree = true;

# base packages
		environment.systemPackages = with pkgs; [
			git vim curl wget
			pciutils usbutils
		];
	};
}
