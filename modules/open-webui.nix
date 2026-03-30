{ config, ... }: let
	local-port = 8081;
in {
	age.secrets.open-webui.file = ../secrets/open-webui.age;

	services.open-webui = {
		enable = true;
		port = local-port;
		environment = {
			ENABLE_OPENAI_API = "true";
			OPENAI_API_BASE_URLS = "https://api.anthropic.com/v1;https://generativelanguage.googleapis.com/v1beta/openai";
		};
		environmentFile = config.age.secrets.open-webui.path;
	};

	services.caddy.virtualHosts."openwebui.jamesbarret.co.uk".extraConfig = ''
		reverse_proxy localhost:${toString local-port}
	'';
}

