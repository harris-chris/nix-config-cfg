**To rebuild**
IF YOU HAVE DONE A VERSION CHANGE THEN REMEMBER TO REBUILD HOME-MANAGER AFTERWARDS; IT IS NOT AUTOMATIC
nixos-rebuild switch --use-remote-sudo .#lemur
nixos-rebuild --use-remote-sudo switch --flake .#lemur

**To rebuild home-manager**
nix build .#homeConfigurations.chris.activationPackage
HOME_MANAGER_BACKUP_EXT="backup-$(date +%Y%m%d%H%M%S)" ./result/activate
swaymsg reload

*Note: The `HOME_MANAGER_BACKUP_EXT` environment variable is required due to the claude-code module expecting it during activation.*

**After cloning**
Any file suffixed ".secret" will have been encrypted with git-crypt. Run `git-crypt unlock` to reset these to plaintext. This is done using the standard GPG key (chrisharriscjh@gmail.com).
