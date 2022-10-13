To rebuild:
nixos-rebuild switch --use-remote-sudo .#lemur

To rebuild home-manager:
nix build .#homeConfigurations.chris-edp.activationPackage
./result/activate
swaymsg reload
