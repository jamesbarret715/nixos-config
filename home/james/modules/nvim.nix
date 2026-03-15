{ pkgs, ... }: {	
	programs.neovim = {
		enable = true;
		plugins = with pkgs.vimPlugins; [
			(nvim-treesitter.withPlugins (p: [
				  p.python
			]))
		];
	};

	home.packages = with pkgs; [
# Language servers
		basedpyright
	];
}
