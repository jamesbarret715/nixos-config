{ config, pkgs, ... }:

{
    sops.secrets.vaultwarden_admin_token = {
	owner = "vaultwarden";
	group = "vaultwarden";
    };

    services.vaultwarden = {
	enable = true;
	config = {
	    DOMAIN = "https://vaultwarden.jamesbarret.co.uk";
	    SIGNUPS_ALLOWED = false;
	    ROCKET_PORT = 8222;
	    ROCKET_ADDRESS = "127.0.0.1";
	};
	environmentFile = config.sops.secrets.vaultwarden_admin_token.path;
    };
}
