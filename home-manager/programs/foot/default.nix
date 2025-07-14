{ pkgs, ... }: #fontSize

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
      };
      colors = {
        background = "08080a";
      };
    };
  };
}
