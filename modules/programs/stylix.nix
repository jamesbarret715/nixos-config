{ inputs, self, ... }: {
	flake-file.inputs.stylix = {
		url = "github:nix-community/stylix";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	flake.modules.nixos.stylix = { pkgs, ... }: {
		home-manager = {
			sharedModules = [ inputs.stylix.homeModules.stylix ];
			users.james.imports = [ self.modules.homeManager.stylix ];
		};

	};

	flake.modules.homeManager.stylix = { pkgs, ... }: {
		stylix = {
			enable = true;
			base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";

			cursor = {
				package = pkgs.posy-cursors;
				name = "Posy_Cursor_Black";
				size = 24;
			};

			fonts = rec {
				monospace = {
					package = pkgs.nerd-fonts.jetbrains-mono;
					name = "JetBrainsMono Nerd Font";
				};

				sansSerif = monospace;
			};

			icons = {
				enable = true;
				package = pkgs.papirus-icon-theme;
				dark = "Papirus-Dark";
				light = "Papirus-Light";
			};
		};
	};
}
