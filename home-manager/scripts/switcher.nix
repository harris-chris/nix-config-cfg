{ config, pkgs, ... }:

let
  cfg   = "/cfg";
  fish   = "${pkgs.fish}/bin/fish";
  rg     = "${pkgs.ripgrep}/bin/rg";
  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
in
  pkgs.writeShellScriptBin "hms" ''
    monitors=$(${xrandr} --query | ${rg} '\bconnected')

    if [[ $monitors == *"eDP"* ]]; then
      echo "Switching to HM config for eDP laptop display"
      cd ${cfg}
      nix build --impure .#homeConfigurations.chris-edp.activationPackage
      result/activate
      cd -
    else
      echo "Could not detect monitor: $monitors"
      exit 1
    fi

    if [[ $1 == "fish" ]]; then
      ${fish} -c fish_update_completions
    fi

    if [[ $1 == "restart" ]]; then
      echo "⚠️ Restarting X11 (requires authentication) ⚠️"
      systemctl restart display-manager
    fi
  ''
