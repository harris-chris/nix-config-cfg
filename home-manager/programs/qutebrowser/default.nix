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
        "<Alt-n>" = "search-prev";
      };
    };
    quickmarks = {
      amazon = "https://www.amazon.co.jp/-/en/";
      aws = "https://signin.aws.amazon.com";
      dhall-prelude = "https://store.dhall-lang.org/Prelude-v21.1.0/index.html";
      ft = "https://www.ft.com";
      gh = "https://github.com";
      gmail = "https://mail.google.com/mail/u/1/#inbox";
      hn = "https://news.ycombinator.com";
      office = "https://www.office.com/?auth=2";
      raphg = "https://hg.lan.raptortt.com";
      redmine-internal = "https://redmine.lan.raptortt.com/";
      redmine-external = "https://redmine.trade-raptor.com/";
      so = "https://www.stackoverflow.com";
      trans = "https://translate.google.com";
      whatsapp = "https://web.whatsapp.com";
      youtube = "https://www.youtube.com/";
      kp-ouch-set-protocol-spec = "https://redmine.lan.raptortt.com/issues/6135";
      kp-ouch-set-risk-filter = "https://redmine.lan.raptortt.com/issues/6031";
      fix_5_sp2 = "https://www.onixs.biz/fix-dictionary/5.0.sp2/index.html";
    };
    searchEngines = {
      DEFAULT = "https://www.google.com/search?hl=en&q={}";
      nixsearch = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&query={}";
      gh = "https://github.com/search?q={}";
      hoogle = "https://hoogle.haskell.org/?hoogle={}&scope=set%3Astackage";
    };
    extraConfig = ''
      c.zoom.default = 150
      c.fonts.default_size = '11pt'
      c.fileselect.handler = 'external'
      c.fileselect.single_file.command = ["foot", "-e", "nnn", "-p", "{}"]
      c.fileselect.multiple_files.command = ["foot", "-e", "nnn", "-p", "{}"]
      c.fileselect.folder.command = ["foot", "-e", "nnn", "-p", "{}"]
      config.load_autoconfig(False)
      c.content.javascript.can_access_clipboard = 'true'
    '';
  };
}
