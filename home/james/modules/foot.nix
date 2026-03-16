{ pkgs, ... }: let 
	iterm2-colorschemes = pkgs.fetchFromGithub {
		owner = "mbadolato";
		repo = "iTerm2-Color-Schemes";
		rev = "4a5043e87c32158f0d7d9f6cdd03f30804c58bce";
		hash = pkgs.lib.fakeSha256;

		sparseCheckout = [
			"foot/TokyoNight*"
		];
	};
in {
	programs.foot = {
		enable = true;

		settings = {
			include = "${iterm2-colorschemes}/foot/TokyoNight Storm.ini"
		};
	};
}
