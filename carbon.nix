{ config, inputs, lib, pkgs, ... }: {
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostName = "carbon";
    networking.hostId = "8425e349";

# kernel
    boot = {
        initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ ];
        kernelModules = [ "kvm-intel" ];
        
        supportedFilesystems = [ "zfs" ]; # root-on-zfs support
        
        kernelParams = [
            "i915.enable_fbc=1" # framebuffer compression
            "i915.enable_guc=3" # graphics microcode (guC/huC)
            "nvidia_drm.fbdev=1"
            "nvidia_drm.modeset=1"
            "quiet"
            "udev.log_level=2"
            "systemd.show_status=auto"
        ];
    };

# bootloader
    boot.loader = {
        systemd-boot.enable = true;
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };

        timeout = 0;
    };
        
    boot.plymouth = {
        enable = true;
        logo = pkgs.runCommand "empty.png" {} "touch $out";
    };
    
# disks
    fileSystems."/boot/efi" = { 
	device = "/dev/nvme0n1p1";
	fsType = "vfat";
	options = [ "fmask=0077" "dmask=0077" ];
    };
    
    fileSystems."/" = {
    	device = "rpool/ROOT/nixos";
    	fsType = "zfs";
    	options = [ "zfsutil" ];
    };
    
    boot.zfs = {
    	extraPools = [ "rpool" ];
    	forceImportRoot = false;
    };
    
# time & locale
    time.timeZone = "Europe/London";
    i18n.defaultLocale = "en_GB.UTF-8";

# nix
    system.stateVersion = lib.mkDefault "26.05";

    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        substituters = [ "https://cache.nixos.org" ];
    };

    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1d";
    };

    nixpkgs.config.allowUnfree = true;

# graphics
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            intel-media-driver
            libvdpau-va-gl
        ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true; # offload power management
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
            offload = {
                enable = true;
                enableOffloadCmd = true;
            };
            # bus IDs for prime offload
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };

# audio 
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };

# networking
    networking.networkmanager = {
        enable = true;
        wifi.powersave = false;
    };

    hardware.bluetooth = { 
        enable = true;
        powerOnBoot = true;
        settings.Policy.AutoEnable = "true";
    };

# security
    security = {
        polkit.enable = true;
        sudo.extraConfig = ''
            Defaults timestamp_type=global
            Defaults timestamp_timeout=30
        '';
    };

# facial recognition
	services.howdy = {
		enable = true;
		control = "sufficient";
	};

	services.linux-enable-ir-emitter.enable = true;
	security.pam.howdy.enable = true;

# system 
    fonts.enableDefaultPackages = true;
    programs.dconf.enable = true;
    services.fwupd.enable = true;

    services.dbus = {
        enable = true;
        implementation = lib.mkDefault "broker";
    };

# optimisations
    hardware.enableRedistributableFirmware = true;
    services.thermald.enable = true;
    services.fstrim.enable = true;
    hardware.cpu.intel.updateMicrocode = true;
    services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
    };
    services.irqbalance.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;	
}
