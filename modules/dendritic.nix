{ inputs, ... }: {
	imports = [
		inputs.flake-file.flakeModules.dendritic
		inputs.flake-file.flakeModules.nix-auto-follow
	];
}
