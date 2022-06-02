{ pkgs, ... }: #fontSize

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
          font = "JetBrainsMono Nerd Font:8";
      };
    };
  };
}
