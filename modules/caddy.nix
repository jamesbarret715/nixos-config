{ config, pkgs, ... }: {
	age.secrets.cloudflare.file = ../secrets/cloudflare.age;

	services.caddy = {
		enable = true;
		package = pkgs.caddy.withPlugins {
			plugins = [ "github.com/caddy-dns/cloudflare@0.2.4"];

		};

		environmentFile = config.age.secrets.cloudflare.path;

		extraConfig = ''
			tls {
				email jamesbarret715@gmail.com
				acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
			}
		'';
	};
}
