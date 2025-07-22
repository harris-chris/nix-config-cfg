{ config, pkgs, lib, ... }:

{
  programs.claude-code = {
    enable = true;
    memory.source = ./claude.md;
    # apiKeyFile = "/home/chris/.config/claude-apikey";
    # …etc…
  };
}
