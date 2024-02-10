{ 
	inputs = { 
		nixpkgs.url = "https://code.theoparis.com/mirrors/nixpkgs/archive/nixpkgs-unstable.tar.gz";
	};

	outputs = {
		self,
		nixpkgs,
	}: {
		nixosConfigurations.riscv = nixpkgs.lib.nixosSystem {
			pkgs = import nixpkgs {
				system = "riscv64-linux";
				config = {
					allowUnfree = false;
					allowBroken = true;
				};
				overlays = [
				];
			};

			system = "riscv64-linux";
			modules = [ 
				./config.nix
			];
		};
	};
}
