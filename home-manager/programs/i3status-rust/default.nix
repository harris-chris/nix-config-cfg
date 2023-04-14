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
             info_type = "available";
             format = "$used / $total";
             alert_unit = "GB";
             warning = 80.0;
             alert = 40.0;
             interval = 60;
           }
           {
             block = "memory";
             format = "$icon $mem_used / $mem_total";
             warning_mem = 80.0;
             critical_mem = 95.0;
           }
           {
             block = "cpu";
             interval = 1;
             format = "$icon $barchart $utilization";
           }
           {
             block = "docker";
             format = "$icon $running / $total";
           }
           {
             block = "net";
             format = "$icon ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) ";
           }
           {
             block = "external_ip";
             format = "$ip $country_code_iso3";
           }
           {
             block = "battery";
             format = "$icon $percentage $time $power";
             warning = 50.0;
             critical = 15.0;
           }
           {
             block = "bluetooth";
             mac = "44:E5:17:13:DB:B5";
           }
           {
             block = "time";
             interval = 60;
             format = "$icon $timestamp.datetime()";
           }

        ];
        icons = "awesome6";
        theme = "space-villain";
      };
    };
  };
}
