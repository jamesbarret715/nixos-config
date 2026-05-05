{ ... }: {
	flake.modules.nixos.misc = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# monitoring
			btop
			nvtopPackages.full
			
			# cli utils
			tree
			unzip
			rsync
			wget
			curl
		];
	};

	flake.modules.homeManager.misc = { pkgs, ... }: {
		home.packages = with pkgs; [
			# multimedia
			pwvucontrol
			spotify
			mpv
			
			# desktop utils
			libnotify
			wl-clipboard
			zathura
			
			# productivity
			bitwarden-desktop
			obsidian
		];
	};
}
