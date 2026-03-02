{ pkgs, ... }: {
	virtualisation = {
		libvirtd = {
			enable = true;
			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = false;
				swtpm.enable = true;
				ovmf = {
					enable = true;
					packages = [ pkgs.OVMFFull ];
				};
			};
		};

# Looking Glass KVMFR kernel module
		kvmfr = {
			enable = true;
			shm = {
				enable = true;
				size = 128;   # MB — adjust to your VM resolution
				user = "james";
				group = "libvirtd";
				mode = "0600";
			};
		};
	};

	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		looking-glass-client
		win-virtio
		bridge-utils
	];
}
