{ pkgs, ... }:
let
  inherit (builtins) isBool;

  isRepoLocked = import ./repoLockedTestResult/default.nix { inherit pkgs; };
  isRepoLockedResult = import isRepoLocked;

in assert isBool isRepoLockedResult; isRepoLockedResult
