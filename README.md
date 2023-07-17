**To rebuild**
nixos-rebuild switch --use-remote-sudo .#lemur
nixos-rebuild --use-remote-sudo switch --flake .#lemur

**To rebuild home-manager**
nix build .#homeConfigurations.chris.activationPackage
./result/activate
swaymsg reload

**After cloning**
Any file suffixed ".secret" will have been encrypted with git-crypt. Run `git-crypt unlock` to reset these to plaintext. This is done using the standard GPG key (chrisharriscjh@gmail.com).
