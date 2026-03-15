{ pkgs, ... }: {
	home.packages = with pkgs; [
		(pkgs.prismlauncher.override {
			 additionalLibs = [
				 nss
				 nspr
				 xorg.libXcomposite
				 xorg.libXdamage
				 xorg.libXrandr
				 xorg.libxcb
				 libxkbcommon
				 alsa-lib
				 mesa
				 expat
				 cups
				 libdrm
			 ];
		 })
	];
}
