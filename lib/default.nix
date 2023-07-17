let
  getPackages = pkgs:
    {
      isRepoLocked = (import ./isRepoLocked.nix { inherit pkgs; });
      readSecret = (import ./readSecret.nix { inherit pkgs; });
    };
in
  {
    overlay = final: prev: getPackages final;
  }
