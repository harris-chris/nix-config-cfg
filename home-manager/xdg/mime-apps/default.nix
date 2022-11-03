{ pkgs, ... }:
{
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [
        "kakoune.desktop"
      ];
      "text/html" = [
        "org.qutebrowser.qutebrowser.desktop"
      ];
      "application/pdf" = [
        "org.qutebrowser.qutebrowser.desktop"
      ];
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
