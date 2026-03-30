{ inputs, ... }: {
	home-manager = {
		extraSpecialArgs = { inherit inputs; };
		sharedModules =  [ 
			inputs.niri.homeModules.niri
			inputs.stylix.homeModules.stylix 
			inputs.nixvim.homeModules.nixvim
		];

		useUserPackages = true;
		backupFileExtension = "bak";

		users.james = import ../../home/james;
	};
}
