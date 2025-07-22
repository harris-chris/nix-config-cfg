{ config, pkgs, ... }:

let
  readSecret = import ../../../lib/readSecret.nix { inherit pkgs; };
  raptor_ldap_password = readSecret "dummy_password" ./raptor_ldap_password.secret;
in
{
  programs.mercurial = {
    enable = true;
    userName = "charris";
    userEmail = "chris.harris@fusionsystems.co.jp";
    iniContent = {
      hostsecurity = {
        "hg.lan.raptortt.com:fingerprints" = "sha256:03:b0:0e:40:2b:69:cd:b4:98:8e:7e:4d:eb:08:88:60:3c:59:7f:6b:cb:df:6d:fd:15:a6:a3:a1:f2:6b:5f:74";
      };
      auth = {
        "raptor.username" = "charris";
        "raptor.schemes" = "http https";
        "raptor.prefix" = "https://hg.lan.raptortt.com/";
        "raptor.password" = raptor_ldap_password;
      };
      extensions = {
        "strip" = "";
        "rebase" = "";
      };
      format = {
        "use-persistent-nodemap" = "no";
      };
    };
  };
}


