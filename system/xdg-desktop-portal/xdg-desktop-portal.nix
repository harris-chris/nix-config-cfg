{ config, lib, pkgs, ... }:
  with lib;
  let xdp = pkgs.xdg-desktop-portal;
  in {
    config = {
      systemd.packages = with pkgs; [
        pipewire
        xdp
        xdg-desktop-portal-wlr
      ];
      systemd.user.sockets.pipewire.wantedBy = [ "sockets.target" ];
      services.dbus.packages = with pkgs; [
        xdp
        xdg-desktop-portal-wlr
      ];
      environment.variables = {
        XDG_DESKTOP_PORTAL_DIR = pkgs.symlinkJoin {
          name = "xdg-portals";
          paths = [ pkgs.unstable.xdg-desktop-portal-wlr ];
        } + "/share/xdg-desktop-portal/portals";
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
      };
    };
  }
