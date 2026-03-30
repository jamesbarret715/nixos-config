{ config, ... }: let 
	local-port = 8222;
in {
	age.secrets.vaultwarden.file = ../secrets/vaultwarden.age;

	services.vaultwarden = {
		enable = true;
		config = {
			DOMAIN = "https://vaultwarden.jamesbarret.co.uk";
			SIGNUPS_ALLOWED = false;
			ROCKET_PORT = local-port;
			ROCKET_ADDRESS = "127.0.0.1";
		};
		environmentFile = config.age.secrets.vaultwarden.path;
	};

	services.caddy.virtualHosts."vault.jamesbarret.co.uk".extraConfig = ''
		tls { dns cloudflare {env.CLOUDFLARE_API_TOKEN} }

		reverse_proxy localhost:${toString local-port}
	'';
 }
