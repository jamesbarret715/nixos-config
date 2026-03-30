{ lib, pkgs, ... }: {
	programs.yazi = {
		enable = true;
		shellWrapperName = "y";
	};

# use yazi as a file chooser
	xdg = {
		enable = true;
		portal = {
			enable = true;
			extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser  ]; 
			config.common = {
				"org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
			};
		};
	};

	xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI {} {
		filechooser = {
			cmd = "${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh";
			env = "TERMCMD='${pkgs.foot}/bin/foot -T \"Yazi\"'";
		};
	};

	home.sessionVariables = {
		"GTK_USE_PORTAL" = 1;
	};
}
