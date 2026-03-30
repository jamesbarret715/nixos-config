{
	description = "NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		awww = { # awww wayland wallpapers 
			url = "git+https://codeberg.org/LGFae/awww"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		firefox-addons = { # firefox extensions
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		home-manager = { 
			url = "github:nix-community/home-manager"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		niri = { # niri window manager 
			url = "github:sodiboo/niri-flake"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		nixvim = { # nixvim neovim with nix 
			url = "github:nix-community/nixvim"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		agenix = { # secrets management 
			url = "github:ryantm/agenix"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};

		stylix = { # stylix theming 
			url = "github:nix-community/stylix"; 
			inputs.nixpkgs.follows = "nixpkgs"; 
		};
	};

	outputs = { self, nixpkgs, ... } @ inputs:  {
		nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules =  [
				./hosts/carbon/core.nix
				./hosts/carbon/home.nix

				inputs.agenix.nixosModules.default
				inputs.home-manager.nixosModules.home-manager

				./modules/bluetooth.nix 
				./modules/game.nix # Options/packages useful for gaming
				./modules/howdy.nix # Windows Hello facial recognition
				./modules/greetd.nix
				./modules/network.nix 
				./modules/pipewire.nix 
				./modules/plymouth.nix # Splash screen at boot
				./modules/virtualisation.nix # Options/packages useful for QEMU/KVM virtualisation
			];
		};

		nixosConfigurations.argon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hosts/argon/core.nix

				inputs.agenix.nixosModules.default

				./modules/caddy.nix
				./modules/open-webui.nix
				./modules/vaultwarden.nix
			];
		};
	};
}

