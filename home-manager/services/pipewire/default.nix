{ pkgs, ... }:
{
  # Note: PipeWire is configured at the system level in NixOS
  # This module only provides user-level audio packages
  home.packages = with pkgs; [
    pavucontrol  # GUI audio control
    pamixer      # CLI audio control
  ];
}