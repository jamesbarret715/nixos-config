{
    description = "jamesbarret715's dead simple nixos";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

		helium = {
			url = "github:AlvaroParker/helium-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    };
    
    outputs = { self, nixpkgs, ... } @ inputs: {
        nixosConfigurations.carbon = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };

            system = "x86_64-linux";
            modules = [ ./carbon.nix ./computer.nix ];
        };
    };
}
