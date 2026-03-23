{ pkgs, ... }: {
	home.packages = with pkgs; [
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
		fd
		file
		fzf
		gemini-cli-bin
		github-cli
		just
		libnotify
		p7zip
		ripgrep
		rsync
		unrar
		unzip
		wl-clipboard
		yazi
		zoxide

# Misc.
		chromium
		librepods

		(prismlauncher.override {
			additionalLibs = [
				nss
				nspr
				atk
				at-spi2-atk
				libdrm
				mesa
				libgbm
				expat
				libX11
				libXcomposite
				libXdamage
				libXext
				libXfixes
				libXrandr
				pango
				cairo
				alsa-lib
				glib
			];
		})
	];
}
