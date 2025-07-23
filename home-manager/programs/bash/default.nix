{ config, pkgs, lib, ... }:

let
  # Colors for solarized theme (matching fish config)
  colors = {
    base03    = "\\[\\033[38;5;8m\\]";   # bright black
    base02    = "\\[\\033[38;5;0m\\]";   # black  
    base01    = "\\[\\033[38;5;10m\\]";  # bright green
    base00    = "\\[\\033[38;5;11m\\]";  # bright yellow
    base0     = "\\[\\033[38;5;12m\\]";  # bright blue
    base1     = "\\[\\033[38;5;14m\\]";  # bright cyan
    base2     = "\\[\\033[38;5;7m\\]";   # white
    base3     = "\\[\\033[38;5;15m\\]";  # bright white
    yellow    = "\\[\\033[38;5;3m\\]";   # yellow
    orange    = "\\[\\033[38;5;9m\\]";   # bright red
    red       = "\\[\\033[38;5;1m\\]";   # red
    magenta   = "\\[\\033[38;5;5m\\]";   # magenta
    violet    = "\\[\\033[38;5;13m\\]";  # bright magenta
    blue      = "\\[\\033[38;5;4m\\]";   # blue
    cyan      = "\\[\\033[38;5;6m\\]";   # cyan
    green     = "\\[\\033[38;5;2m\\]";   # green
    reset     = "\\[\\033[0m\\]";        # reset
  };

  # Git prompt function
  gitPrompt = ''
    __git_ps1_colorize_gitstring() {
      if [[ -n ''${ZSH_VERSION-} ]]; then
        local c_red='%F{red}'
        local c_green='%F{green}'
        local c_lblue='%F{blue}'
        local c_clear='%f'
      else
        local c_red='\[\e[31m\]'
        local c_green='\[\e[32m\]' 
        local c_lblue='\[\e[1;34m\]'
        local c_clear='\[\e[0m\]'
      fi
      local bad_color=$c_red
      local ok_color=$c_green
      local flags_color="$c_lblue"
      
      local branch_color=""
      if [ $detached = no ]; then
        branch_color="$ok_color"
      else
        branch_color="$bad_color"
      fi
      c="$branch_color$c"
      
      z="$c_clear$z"
      if [ "$w" = "*" ]; then
        w="$bad_color$w"
      fi
      if [ -n "$i" ]; then
        i="$ok_color$i"
      fi
      if [ -n "$s" ]; then
        s="$flags_color$s"
      fi
      if [ -n "$u" ]; then
        u="$bad_color$u"
      fi
      r="$c_clear$r"
    }

    __git_prompt() {
      local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
      if [ -n "$git_dir" ]; then
        local branch="$(git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||')"
        if [ -z "$branch" ]; then
          branch="$(git describe --exact-match HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
        fi
        
        local status=""
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
          status="*"
        fi
        
        if [ -n "$branch" ]; then
          echo " ${colors.base01}(${colors.cyan}$branch${colors.red}$status${colors.base01})"
        fi
      fi
    }
  '';

  # Main prompt configuration
  promptConfig = ''
    # Git prompt setup
    ${gitPrompt}
    
    # Custom PS1
    __make_prompt() {
      local last_exit=$?
      
      # Exit status indicator
      local exit_status=""
      if [ $last_exit -ne 0 ]; then
        exit_status="${colors.red}[$last_exit] "
      fi
      
      # Current directory (shortened)
      local pwd_info="${colors.blue}\\w"
      
      # Git information
      local git_info="$(__git_prompt)"
      
      # Nix shell indicator
      local nix_info=""
      if [ -n "$IN_NIX_SHELL" ]; then
        nix_info=" ${colors.violet}[nix]"
      fi
      
      # Final prompt
      PS1="$exit_status${colors.base1}\\u${colors.base01}@${colors.base1}\\h $pwd_info$git_info$nix_info${colors.reset}
${colors.base01}→ ${colors.reset}"
    }
    
    # Set prompt command to update PS1 before each command
    PROMPT_COMMAND="__make_prompt"
  '';
  
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    # History settings
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
    historyFileSize = 10000;
    
    # Shell options
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    
    # Aliases (matching fish config)
    shellAliases = {
      cat = "bat";
      ls = "eza --color=always";
      ll = "ls -a";
      ".." = "cd ..";
      ping = "prettyping";
      v = "nvr";
    };
    
    # Custom initialization
    initExtra = promptConfig;
    
    # Profile extra (for login shells)
    profileExtra = ''
      # Add any login shell specific settings here
    '';
    
    # Session variables
    sessionVariables = {
      # Add any bash-specific environment variables
    };
  };
  
  # Enable fzf integration for bash
  programs.fzf.enableBashIntegration = true;
}