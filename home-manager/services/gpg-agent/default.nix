{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  home.packages = with pkgs; [
    pinentry-curses
  ];

  programs.bash.initExtra = ''
    export GPG_TTY=$(tty)
  '';
}
