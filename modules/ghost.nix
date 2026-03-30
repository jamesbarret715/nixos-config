{ ... }: {
	systemd.tempfiles.rules = [
		"d /var/lib/ghost/content 0755 root root"
	];

	virtualisation = {
		podman.enabled = true;

		oci-containers = {
			backend = "podman";

			containers.ghost = {
				image = "ghost:5-alpine";
				ports = [ "127.0.0.1:2368:2368" ];
				volumes = [
					"/var/lib/ghost/content:/var/lib/ghost/content"
				];
				environment = {
					url = "https://jamesbarret.co.uk";
					database__client = "sqlite3";
					database__connection__filename = "/var/lib/ghost/content/data/ghost.db";
					NODE_ENV = "production";
				};
			};
		};
	};

	services.caddy.virtualHosts."jamesbarret.co.uk".extraConfig = ''
		tls { dns cloudflare {env.CLOUDFLARE_API_KEY} }

		reverse_proxy localhost:2368
	'';
}
