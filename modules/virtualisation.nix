{ pkgs, ... }: {
# Enable libvirt KVM with QEMU
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

# Useful packages
	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		looking-glass-client
		bridge-utils
	];
}
