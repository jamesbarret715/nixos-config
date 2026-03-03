{ pkgs, dwl-src, ... }:

{
	home.packages = with pkgs; [
		(dwl.overrideAttrs (oldAttrs: {
			src = dwl-src;
			
			buildInputs = oldAttrs.buildInputs ++ [
				wlroots_0_19
				libdrm
				fcft
			];
			
			NIX_CFLAGS_COMPILE = "-w";
		}))
	];
}
