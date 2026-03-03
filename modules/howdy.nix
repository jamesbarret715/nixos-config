{ pkgs, ... }:
{
# Enable facial authentication.
	services.howdy = {
		enable = true;
		control = "sufficient";
	};

# Enable the IR emitter.
	services.linux-enable-ir-emitter = {
		enable = true;
	};
}
