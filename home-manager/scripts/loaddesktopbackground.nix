{ config, pkgs, ... }:

pkgs.writeShellScriptBin "loadDesktopBackground" ''
  #!/bin/bash
  feh --bg-scale /cfg/home/pictures/desktop_background.jpg
''
