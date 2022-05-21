{ pkgs, ... }:
{
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "org.qutebrowser.qutebrowser.desktop" "kakoune.desktop" "nvim.desktop" "vim.desktop" ];
    };
  };
  xdg.desktopEntries = {
    kakoune = {
      name = "kakoune";
      exec = "kak";
      terminal = true;
      categories = [ "Application" ];
      mimeType = [ "text/plain" ];
    };
  };
}
