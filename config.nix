{ config, pkgs, ... }:
let
in {
	nix.settings.extra-sandbox-paths = [ "/nix/var/cache/ccache" ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nix.settings.auto-optimise-store = true;
	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 7d";
	};

	fileSystems."/" = {
		device = "/dev/vda2";
		autoResize = true;
		fsType = "btrfs";
		options = [ "noatime" "compress=zstd:8" ];
	};
	fileSystems."/boot" = {
		device = "/dev/vda1";
		fsType = "vfat";
	};

	boot.growPartition = true;
	boot.kernelParams = ["console=ttyS0"];
	boot.loader.grub.device = "nodev";
	boot.loader.grub.efiSupport = true;
	boot.loader.grub.efiInstallAsRemovable = true;

	system.build.image = import <nixpkgs/nixos/lib/make-disk-image.nix> {
		diskSize = 10000;
		format = "qcow2-compressed";
		installBootLoader = true;
		partitionTableType = "efi";
		inherit config lib pkgs;
	};

	users.users.root.initialPassword = "changeme";

	environment.systemPackages = [
		pkgs.plan9port
	];
}
