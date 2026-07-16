{ pkgs, ... }: #fontSize

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Honor the compositor's per-output scale instead of the monitor's
        # physical DPI (from EDID). With "yes", text size is derived from each
        # display's physical DPI and jumps wildly between the laptop panel and
        # an external monitor. Per-output `scale` in sway is the size knob now.
        dpi-aware = "no";
        font = "monospace:size=12";
      };
      colors = {
        background = "08080a";
      };
    };
  };
}
