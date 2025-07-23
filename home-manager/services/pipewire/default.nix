{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Enable RTKit for real-time scheduling
    extraConfig.pipewire = {
      "10-rtkit" = {
        "module.rt" = {
          "rtkit.daemon" = true;
        };
      };
    };
  };

  # Enable WirePlumber session manager
  services.pipewire.wireplumber.enable = true;

  # Ensure user is in audio group for proper permissions
  # Note: This would typically be done at the system level
  home.packages = with pkgs; [
    pipewire
    wireplumber
    pavucontrol  # GUI audio control
    pamixer      # CLI audio control
  ];
}