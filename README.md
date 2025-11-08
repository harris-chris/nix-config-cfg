**To rebuild**
IF YOU HAVE DONE A VERSION CHANGE THEN REMEMBER TO REBUILD HOME-MANAGER AFTERWARDS; IT IS NOT AUTOMATIC
nixos-rebuild switch --use-remote-sudo .#lemur
nixos-rebuild --use-remote-sudo switch --flake .#lemur

**To rebuild home-manager**
nix build .#homeConfigurations.chris.activationPackage
HOME_MANAGER_BACKUP_EXT="backup-$(date +%Y%m%d%H%M%S)" ./result/activate
swaymsg reload

## Home-Manager Configurations

This flake provides two home-manager configurations:

- **`home`**: The main configuration intended for personal workstations
- **`home-server`**: A minimal configuration intended for servers

To build a specific configuration:
```bash
# For main workstation
nix build .#homeConfigurations.chris.activationPackage

# For server
nix build .#homeConfigurations.chris-server.activationPackage
```

## Custom Packages

This repository includes custom derivations for packages that need frequent updates:

- **claude-code** (v1.0.59): Located in `pkgs/claude-code/`. Use `./pkgs/claude-code/upgrade.sh` to update to the latest version, or see `pkgs/claude-code/README.md` for detailed instructions and troubleshooting.

**After cloning**
Any file suffixed ".secret" will have been encrypted with git-crypt. Run `git-crypt unlock` to reset these to plaintext. This is done using the standard GPG key (chrisharriscjh@gmail.com).
