{ pkgs, ... }: {
	services.greetd = {
		enable = true;
		useTextGreeter = true;

		settings = {
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd /home/james/.scripts/start-dwl";
				user = "greeter";
			};
		};
	};
}
