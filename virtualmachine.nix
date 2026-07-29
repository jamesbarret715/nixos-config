{ pkgs, ... }: {
# required boot configuration for PCI devices
	boot = {
		initrd.kernelModules = [
			"vfio_pci"
			"vfio"
			"vfio_iommu_type1"
		];

		kernelParams = [
			"intel_iommu=on"
			"iommu=pt"
		];
	};


# enable virtualisation
	virtualisation = {
		libvirtd = {
			enable = true;

			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = true;

				swtpm.enable = true; # enable TPM emulation
			};

			hooks.qemu."windows-gpu" = ./scripts/windows-gpu.sh;
		};

		spiceUSBRedirection.enable = true;
	};

	users.users.james.extraGroups = [ "libvirtd" ];

	programs.virt-manager.enable = true;

	systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

# networking
	environment.systemPackages = with pkgs; [ dnsmasq ];
	networking.firewall.trustedInterfaces = [ "virbr0" ];
}
