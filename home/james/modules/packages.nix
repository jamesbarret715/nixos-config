{ pkgs, ... }: {
	home.packages = with pkgs; [
# Browsers
		librewolf
		chromium

# Productivity
		obsidian
		onlyoffice-bin
		bitwarden

# Media
		mpv
		handbrake
		blender
		davinci-resolve  # unfree
		reaper

# Dev tools
		gcc
		gnumake
		nodejs
		npm
		uv
		python3
		arduino-cli
		avrdude
		odin

# Ollama with CUDA
		(ollama.override { acceleration = "cuda"; })

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
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji

# System tools
		nvtop
		pavucontrol
		brightnessctl
		wiremix

# Gaming
		mangohud
		wine
		winetricks

# Creative
		freecad

# Network
		wget
		curl
		bind
		meld
	];
}
