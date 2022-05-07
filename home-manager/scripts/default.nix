{ config, pkgs, ... }:

let
  hms = pkgs.callPackage ./switcher.nix { inherit config pkgs; };
  unzip_sjis = pkgs.callPackage ./unzip_sjis.nix { inherit config pkgs; };
in
[
  hms         # custom home-manager switcher that considers the current DISPLAY
  unzip_sjis
]
