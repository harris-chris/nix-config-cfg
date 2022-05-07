{ config, pkgs, ... }:

pkgs.writeShellScriptBin "popupStatus" ''
  #!/bin/bash
  title="$(date +%H:%M)"
  date="$(date +%d) $(date +%B) $(date +%Y), $(date +%A)"
  battery=$( cat /sys/class/power_supply/BAT0/capacity )
  notify-send -i "$title" "$title $date Battery: $battery%"
''
