{ config, pkgs, lib, ... }:

let
  fzfConfig = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

  themeConfig = ''
    set -g theme_display_date no
    set -g theme_nerd_fonts yes
    set -g theme_git_default_branches master main
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

  oh-my-fish = {
    name = "fasd";
    src = pkgs.fetchFromGitHub {
      owner = "oh-my-fish";
      repo = "plugin-fasd";
      rev = "38a5b6b6011106092009549e52249c6d6f501fba";
      sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
    };
  };
in
{
  home = rec {
    packages = with pkgs; [ fasd ];
  };
  programs.fish = {
    enable = true;
    plugins = [ customPlugins.theme fenv oh-my-fish ];
    interactiveShellInit = ''
      # eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';
    shellAliases = {
      cat  = "bat";
      ls   = "eza --color=always";
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
  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = pkgs.lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';
}

