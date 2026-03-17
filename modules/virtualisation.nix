{ config, pkgs, ... }: {
# Kernel tweaks
	boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
	boot.kernelModules = [ "kvm-intel" "kvmfr" ];

# Shared memory
	systemd.tmpfiles.rules = [
		"f /dev/shm/looking-glass 0660 james libvirtd 64M"
	];

	systemd.services.libvirtd.serviceConfig.DeviceAllow = [ "/dev/shm/looking-glass rw" ];

# Enable libvirt KVM with QEMU
	virtualisation = {
		libvirtd = {
			enable = true;
			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = false;
				swtpm.enable = true;

				verbatimConfig = ''
					user = "qemu"
					group = "libvirtd"
					namespaces = []

					# Add /dev/shm to the ACL so QEMU can touch it
					cgroup_device_acl = [
						"/dev/kvm", "/dev/hpet", "/dev/vfio/vfio",
						"/dev/shm/looking-glass", 
						"/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom", "/dev/ptmx", "/dev/rtc"
					]
				'';
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
