{pkgs, ... }:
{
  mode = "dock";
  hiddenState = "hide";
  position = "bottom";
  workspaceButtons = true;
  workspaceNumbers = true;
  statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-default.toml";
  fonts = {
    names = [ "JetBrainsMono" ];
    size = 11.0;
  };
  trayOutput = "primary";
  colors = {
    background = "#000000";
    statusline = "#ffffff";
    separator = "#666666";
    focusedWorkspace = {
      border = "#4c7899";
      background = "#285577";
      text = "#ffffff";
    };
    activeWorkspace = {
      border = "#333333";
      background = "#5f676a";
      text = "#ffffff";
    };
    inactiveWorkspace = {
      border = "#333333";
      background = "#222222";
      text = "#888888";
    };
    urgentWorkspace = {
      border = "#2f343a";
      background = "#900000";
      text = "#ffffff";
    };
    bindingMode = {
      border = "#2f343a";
      background = "#900000";
      text = "#ffffff";
    };
  };
}
