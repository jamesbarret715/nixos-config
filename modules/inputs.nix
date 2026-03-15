{ ... }: {
	services.libinput = {
		touchpad = {
			accelSpeed = "0.0";
			naturalScrolling = true;
		};
		mouse = {
			accelSpeed = "-0.5";
			naturalScrolling = false;
		};
	};
}
