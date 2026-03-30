{ config, pkgs, ... }: {
# Kernel tweaks
	boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
	boot.kernelModules = [ "kvm-intel" "kvmfr" ];

# Shared memory
	systemd.tmpfiles.rules = [
		"f /dev/shm/looking-glass 0660 qemu-libvirtd libvirtd 64M"
	];

	systemd.services.libvirtd.serviceConfig = {
		DeviceAllow = [ 
			"/dev/kvm rw" 
			"/dev/shm/looking-glass rw" 
			"/dev/net/tun rw" 
		];
		PrivateDevices = false;
	};

	virtualisation = {
		docker = {
				enable = true;
				rootless = {
						enable = true;
						setSocketVariable = true;
					};
			};

# Enable libvirt KVM with QEMU
		libvirtd = {
			enable = true;

			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = false;
				swtpm.enable = true;

				verbatimConfig = ''
					namespaces = []
					remember_owner = 0

					cgroup_device_acl = [
						"/dev/kvm", "/dev/hpet", "/dev/vfio/vfio",
						"/dev/shm/looking-glass", 
						"/dev/net/tun",
						"/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom", "/dev/ptmx", "/dev/rtc"
					]
				'';
			};

			hooks.qemu = {
				win11-release = pkgs.writeShellScript "win11-hook" ''
					#!/usr/bin/env bash
					VM_NAME="$1"
					OPERATION="$2"

					GPU_VGA="0000:01:00.0"
					GPU_AUDIO="0000:01:00.1"

					if [[ "$VM_NAME" == "win11" ]]; then
						case "$OPERATION" in
							prepare)
								systemctl set-property --runtime -- user.slice AllowedCPUs=0-3,12-21
								systemctl set-property --runtime -- system.slice AllowedCPUs=0-3,12-21
								systemctl set-property --runtime -- init.scope AllowedCPUs=0-3,12-21

								echo "$GPU_VGA" > /sys/bus/pci/drivers/nvidia/unbind || true
								echo "$GPU_AUDIO" > /sys/bus/pci/drivers/snd_hda_intel/unbind || true

								modprobe vfio-pci
								echo "10de 2860" > /sys/bus/pci/drivers/vfio-pci/new_id || true 
								;;

							release)
								echo "$GPU_VGA" > /sys/bus/pci/drivers/nvidia/bind || true
								echo "$GPU_AUDIO" > /sys/bus/pci/drivers/snd_hda_intel/bind || true

								systemctl set-property --runtime -- user.slice AllowedCPUs=0-21
								systemctl set-property --runtime -- system.slice AllowedCPUs=0-21
								systemctl set-property --runtime -- init.scope AllowedCPUs=0-21
								;;
						esac
					fi	
				'';
			};
		};
	};

	users.groups.kvm.members = [ "qemu" ];

# Useful packages
	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		looking-glass-client
		bridge-utils
	];
}
