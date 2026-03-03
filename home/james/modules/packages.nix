{ pkgs, ... }: {
	home.packages = with pkgs; [
# Browsers
		librewolf
		chromium

# Productivity
		foot
		obsidian
		bitwarden-desktop

# Media
		mpv
		handbrake
		blender

# Devtools
		arduino-cli
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

# Fonts
		nerd-fonts.jetbrains-mono

# System tools
		acpi
		brightnessctl
	];
}
