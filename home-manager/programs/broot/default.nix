{ config, pkgs, ... }:

{
  programs.broot = {
    enable = true;
    verbs = [
      { invocation = "kk"; execution = "kk {file}"; }
      { invocation = "kak"; execution = "kak {file}"; }
    ];
  };
}
