{ config, pkgs, lib, ... }:

{
  programs.claude-code = {
    enable     = true;
    memory.source = ./claude.md;
    package = pkgs.claude-code;
    # apiKeyFile = "/home/chris/.config/claude-apikey";
    # …etc…
  };
}
