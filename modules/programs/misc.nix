{ ... }: {
	flake.modules.nixos.misc = { pkgs, ... }: {
		environment.systemPackages = with pkgs; [
			# monitoring
			btop
			nvtopPackages.full
			
			# cli utils
			curl
			github-cli
			rsync
			tree
			unzip
			wget
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
			ferdium
			obsidian
		];
	};
}
