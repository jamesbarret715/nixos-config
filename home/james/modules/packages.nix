{ pkgs, ... }: {
	home.packages = with pkgs; [
# Browsers
		chromium

# Productivity
		bitwarden-desktop
		ferdium
		obsidian
		onlyoffice-desktopeditors

# Media
		blender
		handbrake
		mpv
		sabnzbd

# Games
		steam
		prismlauncher

# Dev tools
		cargo
		gcc
		gnumake
		nodejs
		odin
		python3
		uv

# CLI tools
		bat
		btop
		eza
		file
		fzf
		gemini-cli-bin
		github-cli
		just
		libnotify
		p7zip
		ripgrep
		rsync
		television
		unrar
		unzip
		wl-clipboard
		yazi
		zoxide

# Misc.
		librepods
	];
}
