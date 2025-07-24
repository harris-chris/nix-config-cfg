# Custom Claude Code Derivation

This is a custom derivation for claude-code that allows you to easily update to new versions independently of nixpkgs.

## Updating to a new version

### Automated upgrade (recommended)

Use the upgrade script to automatically update to the latest version:

```bash
./pkgs/claude-code/upgrade.sh
```

Or update to a specific version:

```bash
./pkgs/claude-code/upgrade.sh 1.0.60
```

For faster upgrades (skip final build test):

```bash
./pkgs/claude-code/upgrade.sh --skip-final-build
```

For slow systems (increase timeout to 15 minutes):

```bash
./pkgs/claude-code/upgrade.sh --build-timeout 900 1.0.60
```

The script will:
1. Fetch the latest version (or use the specified version)
2. Update the source hash
3. Generate a new package-lock.json
4. Get the correct npmDepsHash
5. Test the build
6. Create a backup of the original package.nix

### Manual upgrade

If you prefer to update manually:

1. **Check for the latest version:**
   ```bash
   npm view @anthropic-ai/claude-code version
   ```

2. **Update the version in package.nix:**
   - Change the `version` field to the new version number
   - Set `npmDepsHash = lib.fakeHash;` temporarily

3. **Update the source hash:**
   - Build the derivation and it will fail with the correct hash
   - Copy the "got: sha256-..." value and update the `hash` field

4. **Generate new package-lock.json:**
   ```bash
   ./update.sh
   ```

5. **Get the correct npmDepsHash:**
   - Build again and it will fail with the correct npmDepsHash
   - Copy the "got: sha256-..." value and update the `npmDepsHash` field

6. **Test the build:**
   ```bash
   nix build .#homeConfigurations.chris.activationPackage
   ```

## Troubleshooting

### Hash mismatch errors

If you encounter hash mismatch errors after running the upgrade script:

1. **For source hash mismatch:**
   ```
   error: hash mismatch in fixed-output derivation '...source.drv'
   ```
   - Update the `hash` field in package.nix with the "got:" value from the error

2. **For npmDepsHash mismatch:**
   ```
   error: hash mismatch in fixed-output derivation '...npm-deps.drv'
   ```
   - Update the `npmDepsHash` field in package.nix with the "got:" value from the error

3. **If both hashes end up the same:**
   - This indicates an error - source hash and npmDepsHash should be different
   - Try the manual upgrade process instead

## Current version

This derivation is currently configured for claude-code version **1.0.59**.