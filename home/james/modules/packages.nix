{ pkgs, ... }: {
	home.packages = with pkgs; [
# Browsers
		librewolf
		chromium

# Productivity
		obsidian
		bitwarden-desktop

# Media
		mpv
		handbrake
		blender

# Dev tools
		gcc
		gnumake
		nodejs
		uv
		python3
		arduino-cli
		avrdude
		odin

# Ollama with CUDA
# (ollama.override { acceleration = "cuda"; })

# CLI tools
		btop
		ripgrep
		just
		rsync
		unzip
		unrar
		p7zip

# Wayland utils
		wl-clipboard
		wlr-randr
		swaybg

# Fonts
		nerd-fonts.jetbrains-mono

# System tools
		pavucontrol
		brightnessctl

# Gaming
		mangohud
		wine
		winetricks

# Creative
# Network
		wget
		curl
		bind
		meld
	];
}
