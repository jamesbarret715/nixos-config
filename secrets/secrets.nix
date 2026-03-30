let 
	admin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGTXRLWM/G+JzpFxlxa39Lt1touZvTFYp5mENysbb23";
in {
	"vaultwarden.age".publicKeys = [ admin ];
	"open-webui.age".publicKeys  = [ admin ];
	"cloudflare.age".publicKeys  = [ admin ];
	"murmur.age".publicKeys      = [ admin ];
}
