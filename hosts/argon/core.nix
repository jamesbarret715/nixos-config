{ pkgs, lib, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	system.stateVersion = "25.11";
	networking.hostName = "argon";

	boot = {
		kernelParams = [ "root=/dev/sda2" "console=ttyS0,115200n8" ];

		loader.grub = {
			enable = true;
			devices = lib.mkForce [ "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0" ];
		};
	};

# Basic networking
	networking = {
		useDHCP = true;
		defaultGateway = "31.97.59.254";
		nameservers = [ "8.8.8.8" "1.1.1.1" ];
		interfaces.ens18.ipv4.addresses = [{
			address = "31.97.59.153";
			prefixLength = 24;
		}];
	};

	time.timeZone = "Europe/London";
	i18n.defaultLocale = "en_GB.UTF-8";

# Only allow SSH key auth, no passwords
	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = false;
			PermitRootLogin = "no";
		};
	};

	users.users.admin = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGTXRLWM/G+JzpFxlxa39Lt1touZvTFYp5mENysbb23"
		];
	};

# Allow admin to sudo without password (convenient for a personal server)
	security.sudo.extraRules = [{
		users = [ "admin" ];
		commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }];
	}];

	environment.systemPackages = with pkgs; [
		vim
		git
		curl
		wget
	];

# Firewall - only allow SSH, HTTP, HTTPS
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 22 80 443 ];
	};

	nix.settings = {
		trusted-users = [ "admin" ];
		experimental-features = [ "nix-command" "flakes" ];
	};

	nixpkgs.config.allowUnfree = true;

	age.identityPaths = [ "/home/admin/.ssh/id_ed25519_argon" ];
}
