{ config, pkgs, ... }:

{
  programs.broot = {
    enable = true;
    settings.verbs = [
      {
        invocation = "touch {new_file}";
        external = "touch {directory}/{new_file}";
        leave_broot=false;
      }
    ];
  };
}
