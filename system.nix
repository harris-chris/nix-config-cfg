{ lib, inputs, nixos-hardware, system, ... }:

{
  dell-xps = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./system/machine/dell-xps
      ./system/configuration.nix
    ];
  };
  lemur = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
        nixos-hardware.nixosModules.system76
        ./system/machine/lemur
        ./system/configuration.nix
      ];
  };

}
