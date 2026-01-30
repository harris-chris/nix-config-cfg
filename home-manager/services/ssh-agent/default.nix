{ pkgs, ... }:

{
  services.ssh-agent = {
    enable = false;  # Using keychain instead
  };
}
