{ config, lib, pkgs, ... }: {
	age.secrets.murmur.file = ../secrets/murmur.age;

	services.murmur = {
		enable = true;
		openFirewall = true;
		environmentFile = config.age.secrets.murmur.path;

		registerName = "James Barret's Mumble Server";
		password = "$MURMURD_PASSWORD";
	};

	systemd.services.murmur.preStart = lib.mkAfter ''
		${pkgs.murmur}/bin/mumble-server \
			-ini /run/murmur/murmurd.ini \
			-supw $MURMURD_SUPW
	'';
}
