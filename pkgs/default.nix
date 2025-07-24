{ pkgs }:

{
  claude-code = pkgs.callPackage ./claude-code/package.nix { };
}