{ pkgs, ... }: {
	programs.television = {
		enable = true;
		enableZshIntegration = true;
	};

	home.packages = with pkgs; [
		fd # for files channel
	];
}
