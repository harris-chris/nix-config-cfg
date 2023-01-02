To rebuild:
nixos-rebuild switch --use-remote-sudo .#lemur
nixos-rebuild --use-remote-sudo switch --flake .#lemur

To rebuild home-manager:
nix build .#homeConfigurations.chris-edp.activationPackage
./result/activate
swaymsg reload
