{ pkgs, ... }: {
	virtualisation = {
		libvirtd = {
			enable = true;
			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = false;
				swtpm.enable = true;
			};
		};
	};

	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		looking-glass-client
		bridge-utils
	];
}
