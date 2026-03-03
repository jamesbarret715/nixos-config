{ ... }: {
# Enable plymouth
	boot.plymouth = {
		enable = true;
		theme = "spinner";
	};

# Additional boot params
	boot = {
		initrd.verbose = false;
		kernelParams = [
			"quiet"
			"udev.log_level=2"
			"systemd.show_status=auto"
		];

		loader.timeout = 0;
	};
}
