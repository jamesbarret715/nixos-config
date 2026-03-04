{ pkgs, ... }: {
# Enable plymouth
	boot.plymouth = {
		enable = true;
		theme = "spinner_alt";
		logo = pkgs.runCommand "empty.png" {} "touch $out";

		themePackages = with pkgs; [
			(adi1090x-plymouth-themes.override {
				selected_themes = [ "spinner_alt" ];
			})
		];
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
