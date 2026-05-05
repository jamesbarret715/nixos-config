{ ... }: {
	flake.modules.homeManager.zsh = { config, pkgs, ... }: {
		home.packages = with pkgs; [
			eza
			fd
			bat
			ripgrep
			fzf
			zoxide
		];

		programs.zsh = {
			enable = true;	

			defaultKeymap = "viins";
			autocd = true;

			setOptions = [
				"INC_APPEND_HISTORY"
			];

			history = {
				path = "${config.xdg.configHome}/zsh/zsh_history";

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
				source <(${pkgs.fzf}/bin/fzf --zsh)
				source <(${pkgs.zoxide}/bin/zoxide init zsh)

				export FZF_DEFAULT_COMMAND='${pkgs.fd}/bin/fd --type f'
			'';
		};
	};
}
