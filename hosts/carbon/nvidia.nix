{ config, pkgs, ... }: {
# Nvidia proprietary driver
	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = true;
		powerManagement.finegrained = true;   # fine-grained power management (RTX)
		open = false;                     # proprietary, not open kernel module
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;

		prime = {
			offload = {
				enable = true;
				enableOffloadCmd = true;   # gives you `nvidia-offload` command
			};

			intelBusId = "PCI:0:2:0";
			nvidiaBusId = "PCI:1:0:0";
		};
	};

# Intel Arc iGPU
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [
			intel-media-driver    # VAAPI for Intel Arc
			vpl-gpu-rt            # Intel VPL (video processing)
			nvidia-vaapi-driver   # VAAPI bridge for Nvidia when offloading
		];
		extraPackages32 = with pkgs; [
			pkgs.driversi686Linux.intel-media-driver
		];
	};

	environment.sessionVariables = {
# Use Intel for display, Nvidia only on request
		WLR_DRM_DEVICES = "/dev/dri/card1";   # Intel Arc is card1
		LIBVA_DRIVER_NAME = "iHD";            # Intel VAAPI
	};
}
