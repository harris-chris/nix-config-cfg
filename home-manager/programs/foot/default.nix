{ pkgs, ... }: #fontSize

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=7";
        dpi-aware = "yes";
      };
      colors = {
        background = "08080a";
      };
    };
  };
}
