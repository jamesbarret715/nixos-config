{ config, pkgs, ... }: {
	programs.zsh = rec {
		enable = true;	
		dotDir = "${config.xdg.configHome}/zsh";

		defaultKeymap = "viins";
		autocd = true;

		setOptions = [
			"INC_APPEND_HISTORY"
		];

		history = {
			path = "${dotDir}/zsh_history";

			append = true;
			ignoreDups = true;
			save = 10000;
			size = 20000;
		};

		shellAliases = {
			"open" = "${pkgs.xdg-utils}/bin/xdg-open";

			"ls" = "${pkgs.eza}/bin/eza --color=auto -h";
			"ll" = "ls -l";
			"la" = "ls -la";

			"find" = "${pkgs.fd}/bin/fd";
			"cat" = "${pkgs.bat}/bin/bat";
			"grep" = "${pkgs.ripgrep}/bin/rg";
		};
		
		initContent = ''
			source <(fzf --zsh)
		'';
	};
}
