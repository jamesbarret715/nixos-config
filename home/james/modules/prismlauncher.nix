{ pkgs, ... }: {
	programs.prismlauncher = {
		enable = true;
		package = let 
			prismlauncher-fhs = pkgs.buildFHSEnv {
				name = "prismlauncher";
				targetPkgs = pkgs: with pkgs; [
					prismlauncher

					nss
					nspr
					atk
					at-spi2-atk
					cups
					libdrm
					dbus
					expat
					libX11
					libXcomposite
					libXdamage
					libXext
					libXfixes
					libXrandr
					libgbm
					pango
					cairo
					alsa-lib
					mesa # for libGL
				];

				runScript = "prismlauncher";
			};
		in pkgs.symlinkJoin {
			name = "prismlauncher";
			paths = [
				prismlauncher-fhs 
				pkgs.prismlauncher
			];
		};
	};
}
