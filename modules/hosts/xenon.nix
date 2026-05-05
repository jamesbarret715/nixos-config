{ lib, self, ... }: {
	flake.nixosConfigurations.xenon = lib.nixosSystem {
		modules = with self.modules.nixos; [
			xenon-hardware

			core
			desktop
			
			{
				services.openssh.enable = true;
			}
		];
	};

	flake.modules.nixos.xenon-hardware = {
		nixpkgs.hostPlatform = "x86_64-linux";
		networking.hostName = "xenon";

		boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" ];

		hardware.graphics.enable = true;
	};
}
