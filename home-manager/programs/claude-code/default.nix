{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.claude-code ];
  
  # Set up claude memory file
  home.file.".claude/CLAUDE.md".source = ./claude.md;
}
