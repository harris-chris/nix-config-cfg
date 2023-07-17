{ pkgs, ... }:
let
  inherit (builtins) trace readFile;

  isRepoLocked = import ./isRepoLocked.nix { inherit pkgs; };

  readSecret = if isRepoLocked
    then default: file:
      trace
        "WARNING: Building from locked repo. Secrets will be replaced with placeholders."
        default
    else default: file:
      pkgs.lib.strings.removeSuffix "\n" (readFile file);
in
readSecret
