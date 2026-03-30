{ config, ... }: let 
	local-port = 8222;
in {
	sops.secrets.vaultwarden_admin_token = {
		owner = "vaultwarden";
		group = "vaultwarden";
	};

	services.vaultwarden = {
		enable = true;
		config = {
			DOMAIN = "https://vaultwarden.jamesbarret.co.uk";
			SIGNUPS_ALLOWED = false;
			ROCKET_PORT = local-port;
			ROCKET_ADDRESS = "127.0.0.1";
		};
		environmentFile = config.sops.secrets.vaultwarden_admin_token.path;
	};

	services.caddy.virtualHosts = {
		"vaultwarden.jamesbarret.co.uk".extraConfig = ''
			redir https://vault.jamesbarret.co.uk{uri} permanent
		'';

		"vault.jamesbarret.co.uk".extraConfig = ''
			reverse_proxy localhost:${toString local-port}
		'';
	};
 }
