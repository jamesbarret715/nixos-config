{ inputs, ... }: {
    flake-file.inputs.home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    flake.modules.nixos.home-manager = {
        imports = [ inputs.home-manager.nixosModules.home-manager ];

        home-manager = {
            useGlobalPkgs = false;
            useUserPackages = false;
            extraSpecialArgs = { inherit inputs; };
			backupFileExtension = "old";

			users.james = {
				nixpkgs.config.allowUnfree = true;
			};
        };
    };
}
