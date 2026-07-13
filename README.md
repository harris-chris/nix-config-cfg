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

**After cloning**
Any file suffixed ".secret" will have been encrypted with git-crypt. Run `git-crypt unlock` to reset these to plaintext. This is done using the standard GPG key (chrisharriscjh@gmail.com).

## Flashing the Corne keyboard (QMK)

The Corne (crkbd/rev1) is a split keyboard built on two **Elite-C** controllers. The
keymap lives at `keymaps/corne.json` (a QMK Configurator export — edit it at
<https://config.qmk.fm> or by hand).

Required tooling is already provided by this config:
- Packages: `qmk`, `dfu-programmer`, `dos2unix` (in `home-manager/home.nix`).
- udev rules for non-root flashing: `hardware.keyboard.qmk.enable = true` (in
  `system/configuration.nix`).

One-time QMK setup (clones the firmware sources to `~/qmk_firmware`):
```bash
qmk setup
```

**Important — bootloader:** the Elite-C uses the **Atmel DFU** bootloader, but
`crkbd/rev1`'s QMK default is `caterina` (Pro Micro). Flashing without overriding this
hangs at `Waiting for USB serial port` because it's looking for the wrong device. Always
pass `-bl dfu -e BOOTLOADER=atmel-dfu`.

Flash each half separately (plug in one half at a time via USB-C):
```bash
qmk flash keymaps/corne.json -bl dfu -e BOOTLOADER=atmel-dfu
```
When it prints `Waiting for USB device`, reset that half (double-tap the reset button, or
short `RST`↔`GND`). It enters DFU mode (`lsusb` shows `03eb:2ff4 Atmel`), then
dfu-programmer erases/writes/resets. Repeat for the other half.

To compile only (produces a `.hex` without flashing):
```bash
qmk compile keymaps/corne.json
```
