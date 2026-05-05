{ ... }: {
	flake.modules.nixos.thunar = { pkgs, ... }: {
		programs.thunar = {
			enable = true;
			plugins = with pkgs; [
				thunar-archive-plugin
				thunar-volman
			];
		};

		# mounting and other services required for thunar to be useful
		services.gvfs.enable = true;
		services.tumbler.enable = true; # thumbnails
	};

	flake.modules.homeManager.thunar = { ... }: {
		# xdg-utils will use thunar
		xdg.mimeApps.defaultApplications = {
			"inode/directory" = "thunar.desktop";
		};
	};
}
