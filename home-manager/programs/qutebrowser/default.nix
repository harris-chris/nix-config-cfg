let

in {
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "<Ctrl-h>" = "tab-prev";
        "<Ctrl-l>" = "tab-next";
        "<Shift-r>" = "reload";
        "<Shift-h>" = "back";
        "<Ctrl-+>" = "set zoom.default 150";
        "<Ctrl-->" = "set zoom.default 100";
        "b" = "back";
        "h" = "tab-prev";
        "l" = "tab-next";
      };
    };
    searchEngines = {
      DEFAULT = "https://www.google.com/search?hl=en&q={}";
      nixsearch = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
      gh = "https://github.com/search?q={}";
      hoogle = "https://hoogle.haskell.org/?hoogle={}&scope=set%3Astackage";
    };
    extraConfig = ''
      c.fonts.default_size = '11pt'
      c.fileselect.handler = 'external'
      c.fileselect.single_file.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      c.fileselect.multiple_files.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      c.fileselect.folder.command = ["alacritty", "-e", "nnn", "-p", "{}"]
      config.load_autoconfig(False)
    '';
  };
}
