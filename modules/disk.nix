{ lib, ... }:

{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = "/dev/sdb";
				content = {
					type = "gpt";
					partitions = {
						boot = {
							size = "1M";
							type = "EF02"; # BIOS boot partition for GRUB
						};
						root = {
							size = "100%";
							content = {
								type = "filesystem";
								format = "ext4";
								mountpoint = "/";
							};
						};
					};
				};
			};
		};
	};
}
