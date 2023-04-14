{ pkgs, ... }: #fontSize

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
          font = "JetBrainsMono Nerd Font:size=7";
          dpi-aware = "auto";
      };
      colors = {
          background = 040404;
      };
      # key-bindings = {
      #   scrollback-up-half-page = "Alt+u";
      #   scrollback-down-half-page = "Alt+d";
      # };
    };
  };
}
