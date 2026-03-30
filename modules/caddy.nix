{ config, pkgs, ... }:

{
    services.caddy = {
	enable = true;

	virtualHosts."vaultwarden.jamesbarret.co.uk" = {
	    extraConfig = ''
		reverse_proxy localhost:8222
	    '';
	};
    };
}
