{ pkgs, ... }: {
	home.packages = with pkgs; [
# Browsers
		librewolf
		chromium

# Productivity
		bitwarden-desktop
		ferdium
		foot
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
		swaybg


# System tools
		acpi
		brightnessctl
		libnotify
		grim
		slurp
	
# Misc.
		librepods
		nerd-fonts.jetbrains-mono
	];
}
