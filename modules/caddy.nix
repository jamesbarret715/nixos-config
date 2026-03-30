{ config, pkgs, ... }: {
	age.secrets.cloudflare.file = ../secrets/cloudflare.age;

	services.caddy = {
		enable = true;
		package = pkgs.caddy.withPlugins {
			plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4"];
			hash = "sha256-8HpPZ/VoiV/k0ZYcnXHmkwuEYKNpURKTN19aYZRLPoM=";
		};

		environmentFile = config.age.secrets.cloudflare.path;
	};
}
