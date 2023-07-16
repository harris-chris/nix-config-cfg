{ pkgs, ... }:
let
  kakoune-expand = builtins.readFile ./kakoune-expand.kak;
  smarttab = builtins.readFile ./smarttab.kak;
  ayu-mirage = builtins.readFile ./ayu-mirage.kak;
  tab-options = ''
    hook global ModuleLoaded smarttab %{
      set-option global softtabstop 2
      hook global WinSetOption expandtab
      hook global WinSetOption filetype=makefile %{
          noexpandtab
      }
      hook global WinSetOption filetype=haskell %{
          expandtab
          set-option global indentwidth 4
      }
      hook global WinSetOption filetype=python %{
          expandtab
          set-option global indentwidth 4
      }
      hook global WinSetOption filetype=dhall %{
          expandtab
          set-option global indentwidth 4
      }
      hook global WinSetOption filetype=nix %{
          expandtab
          set-option global indentwidth 2
      }
      hook global WinSetOption filetype=julia %{
          expandtab
          set-option global indentwidth 4
      }
    }
    require-module smarttab
  '';

  basicExtraConfig = ''
    decl str grepcmd 'rg --column'
    # Highlight search matches in italic
    add-highlighter global/ dynregex '%reg{/}' 0:+i
    def find -params 1 -shell-script-candidates %{ find . -type f } %{ edit %arg{1} }
    def git-edit -params 1 -shell-script-candidates %{ git ls-files } %{ edit %arg{1} }

    eval %sh{kak-lsp --kakoune -s $kak_session}
    lsp-enable
    hook global WinSetOption filetype=rust %{
      set-option global lsp_server_configuration rust.clippy_preference="on"
      lsp-auto-hover-enable
    }
    hook global ModuleLoaded fzf-file %{
      set-option global fzf_file_command 'fd'
    }
    hook global ModuleLoaded fzf %{
      set-option global fzf_highlight_command 'bat'
      set-option global termcmd 'foot -e sh -c'
      set-option global fzf_implementation 'sk'
    }
  '';

in rec {
  home = rec {
    packages = with pkgs; [
      xsel ripgrep kak-lsp
      rnix-lsp rust-analyzer
      skim
      haskell-language-server
      # dhall-lsp-server
      # haskell.compiler.ghc943
      # haskellPackages.Cabal_3_4_0_0
      # cabal-install ghc8107
    ];

    sessionVariables = {
      EDITOR = "kk";
    };

    file."kak-lsp.toml" = {
      target = ".config/kak-lsp/kak-lsp.toml";
      text = ''
        snippet_support = false
        verbosity = 2
        [sematic_scopes]
        variable = "variable"
        entity_name_function = "function"
        entity_name_type = "type"
        variable_other_enummember = "variable"
        entity_name_namespace = "module"
        [server]
        timeout = 1800
        [language.rust]
        filetypes = ["rust"]
        roots = ["Cargo.toml"]
        command = "rust-analyzer"
        [language.nix]
        filetypes = ["nix"]
        roots = [".git"]
        command = "rnix-lsp"
       	[language.haskell]
      	filetypes = ["haskell"]
      	roots = ["Setup.hs", "stack.yaml", "*.cabal"]
      	command = "haskell-language-server"
      	args = ["--lsp"]
        # [language.dhall]
        # filetypes = ["dhall"]
        # roots = []
        # command = "dhall-lsp-server"
      '';
    };
  };

  programs = rec {
    kakoune = {
      enable = true;

      plugins = with pkgs.kakounePlugins; [
        kak-fzf
        powerline-kak
        kakboard
      ];

      config = {
        #colorScheme = "gruvbox";
        showMatching = true;
        wrapLines.enable = true;
        indentWidth = 2;

        ui = {
          setTitle = true;
          assistant = "none";
          enableMouse = false;
        };

        numberLines = {
          enable = true;
          relative = false;
          highlightCursor = true;
        };

        autoReload = "yes";

        scrollOff = {
          lines = 3;
        };

        keyMappings = [
          {
            mode = "normal";
            key = "<c-t>";
            effect = ": fzf-mode<ret>";
          }
          {
            mode = "normal";
            key = "<c-n>";
            effect = "<a-n>";
          }
          {
            mode = "normal";
            key = "'#'";
            effect = ":comment-line<ret>";
          }
          {
            mode = "normal";
            key = "<c-y>";
            effect = "<a-J>";
          }
        ];

        hooks = [
          {
            name = "WinSetOption";
            option = "filetype=rust";
            commands = "set global makecmd 'cargo'";
          }
          {
            name = "WinCreate";
            option = ".*";
            commands = "kakboard-enable";
          }
          {
            name = "InsertCompletionShow";
            option = ".*";
            commands = ''try %{
              #execute-keys -draft 'h<a-K>\h<ret>'
              map window insert <tab> <c-n>
              map window insert <s-tab> <c-p>
              hook -once -always window InsertCompletionHide .* %{
                  map window insert <tab> <tab>
                  map window insert <s-tab> <s-tab>
              }
            }'';
          }

          # Trim trailing whitespaces
          {
            name = "BufWritePre";
            option = ".*";
            commands = "try %{ execute-keys -draft \\%s\\h+$<ret>d }";
          }
        ];
      };
    extraConfig = basicExtraConfig + kakoune-expand + smarttab + ayu-mirage + tab-options ;
    };
  };
}
