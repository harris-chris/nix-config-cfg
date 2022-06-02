{ pkgs, ... }:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
             block = "disk_space";
             path = "/";
             alias = "/";
             info_type = "available";
             format = "{used} / {total}";
             alert_absolute = true;
             unit = "GB";
             warning = 80.0;
             alert = 40.0;
             interval = 60;
           }
           {
             block = "memory";
             display_type = "memory";
             format_mem = "{mem_used_percents}";
             format_swap = "{swap_used_percents}";
           }
           {
             block = "cpu";
             interval = 1;
           }
           {
             block = "docker";
             format = "{running} /{total} ";
           }
           {
             block = "net";
             format = "{speed_down} {speed_up}";
           }
           {
             block = "external_ip";
             format = "{ip} {country_code_iso3}";
           }
           {
             block = "battery";
             format = "{percentage}  {time}  {power}";
           }
           {
             block = "bluetooth";
             mac = "44:E5:17:13:DB:B5";
           }
           {
             block = "time";
             interval = 60;
             format = "%a %Y-%m-%d %R";
           }

        ];
        icons = "awesome6";
        theme = "space-villain";
      };
    };
  };
}
