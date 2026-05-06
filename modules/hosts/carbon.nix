{ lib, self, ... }: {
	flake.nixosConfigurations.carbon = lib.nixosSystem {
		modules = with self.modules.nixos; [
			carbon-hardware

			core
			laptop
			gaming

			{ home-manager.sharedModules = [
				self.modules.homeManager.carbon-display 
			]; }
		];
	};

	flake.modules.nixos.carbon-hardware = { config, pkgs, ... }: {
		nixpkgs.hostPlatform = "x86_64-linux";
		networking.hostName = "carbon";

		# kernel
		boot.kernelPackages = pkgs.linuxPackages_zen; 
		boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ "kvm-intel" ];
		
		boot.kernelParams = [
			"i915.enable_fbc=1" # frame buffer compression
			"i915.enable_guc=3" # graphics microcode (guC/huC)
			"nvidia_drm.fbdev=1"
			"nvidia_drm.modeset=1"
		];

		# graphics
		hardware.graphics = {
			enable = true;
			enable32Bit = true;
			extraPackages = with pkgs; [
				intel-media-driver
				libvdpau-va-gl
			];
		};

		# nvidia
		services.xserver.videoDrivers = [ "nvidia" ];
		hardware.nvidia = {
			modesetting.enable = true;
			powerManagement.enable = true;
			powerManagement.finegrained = true; # offload power management
			open = false;
			nvidiaSettings = true;
			package = config.boot.kernelPackages.nvidiaPackages.stable;

			prime = {
				offload = {
					enable = true;
					enableOffloadCmd = true;
				};
				# bus IDs for prime offload
				intelBusId = "PCI:0:2:0";
				nvidiaBusId = "PCI:1:0:0";
			};
		};

		# optimisations
		hardware.enableRedistributableFirmware = true;
		services.thermald.enable = true;
		services.fstrim.enable = true;
		zramSwap.enable = true;
		hardware.cpu.intel.updateMicrocode = true;
		services.ananicy = {
			enable = true;
			package = pkgs.ananicy-cpp;
		};
		services.irqbalance.enable = true;
	};

	flake.modules.homeManager.carbon-display = {
# get niri to use the built-in display nicely
		programs.niri.settings.outputs."eDP-1" = {
			enable = true;
			mode = { width = 2880; height = 1800; refresh = 120.0; };
			position = { x = 0; y = 1080; };
			variable-refresh-rate = true;
			scale = 1.5;
		};
	};
}
