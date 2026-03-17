{ pkgs, awww, ... }: {
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
		fzf
		gemini-cli-bin
		github-cli
		just
		p7zip
		ripgrep
		rsync
		unrar
		unzip

# Wayland utils
		wl-clipboard

# System tools
		acpi
		libnotify
	
# Misc.
		librepods
	];
}
