{ config, pkgs, lib, ... }:

let
  fzfConfig = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

  themeConfig = ''
    set -g theme_display_date no
    set -g theme_nerd_fonts yes
    set -g theme_display_git_master_branch no
    set -g theme_nerd_fonts yes
    set -g theme_newline_cursor yes
    set -g theme_color_scheme solarized
  '';

  customPlugins = pkgs.callPackage ./plugins.nix {};

  fenv = {
   name = "foreign-env";
   src = pkgs.fishPlugins.foreign-env.src;
  };

  fishConfig = ''
    #bind \t accept-autosuggestion
    function save_history --on-event fish_postexec
        history --save
    end
    function merge_history --on-event fish_preexec
        history --merge
    end
    bind \ce edit_command_buffer
    bind -e --preset \cd delete-or-exit
    set fish_greeting
  '' + fzfConfig + themeConfig;
in
{
  programs.fish = {
    enable = true;
    plugins = [ customPlugins.theme fenv ];
    interactiveShellInit = ''
      # eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      cat  = "bat";
      ls   = "exa --color=always";
      ll   = "ls -a";
      ".." = "cd ..";
      ping = "prettyping";
      "v"  = "nvr";
    };
    functions = {
      grepl = {
        description = "grep case-insensitive and pipe to less with colours";
        body = ''
        if count $argv > /dev/null
          grep -ir --color=always $argv | less -R
        end
        '';
      };
      rgl = {
        description = "rg and pipe to less with colours";
        body = ''
        if count $argv > /dev/null
          rg --pretty --smart-case $argv | less -R
        end
        '';
      };
      fdl = {
        description = "rg and pipe to less with colours";
        body = ''
        if count $argv > /dev/null
          fd --color=always $argv | less -R
        end
        '';
      };    };
    shellInit = fishConfig;
  };

  xdg.configFile."fish/functions/fish_prompt.fish".text = customPlugins.prompt;
}

