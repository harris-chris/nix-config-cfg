{ lib, inputs, system, ... }:

{
  dell-xps = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./system/machine/dell-xps
      ./system/configuration.nix
    ];
  };

}
