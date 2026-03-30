{ pkgs, lib, ... }: {
	system.stateVersion = "25.11";
	networking.hostName = "argon";

# Use grub2 as a bootloader
	boot = {
		kernelParams = [ "root=/dev/sda2" "console=ttyS0,115200n8" ];

		loader.grub = {
			enable = true;
			devices = lib.mkForce [ "/dev/sda" ];
		};
	};

# Basic networking
	networking.useDHCP = true;

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
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMj1LWPax+WAtOGubXR+VV9kcBhUwsgFuufaMY63a2yM"
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

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

# SOPS
	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
	};
}
