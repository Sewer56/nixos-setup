{
  pkgs,
  config,
  ...
}: let
  caCert = pkgs.writeText "nexus-vpn-ca.pem" ''
    -----BEGIN CERTIFICATE-----
    MIIDOjCCAiKgAwIBAgIBADANBgkqhkiG9w0BAQsFADAdMRswGQYDVQQDExJmcmVl
    cmFkaXVzLXRlbXAtY2EwHhcNMjAxMDAyMDk1MjM4WhcNMzAwOTMwMDk1MjM4WjAd
    MRswGQYDVQQDExJmcmVlcmFkaXVzLXRlbXAtY2EwggEiMA0GCSqGSIb3DQEBAQUA
    A4IBDwAwggEKAoIBAQCkUprla/2AhLZt1AXZmM9P7P+x1b6XsK96F/Qefv8B8Hiz
    wKg+nhDItDDo/sPZXqxx3oABDzBep23tlZmGVZnjIKRs+8SeUbdti3K9n0MPV/QD
    rpxVdfpWDZoBPYeDNdC9XvNZV0vlDv7kSq4Fv4CZ8R7LWF9rq+jxg/swAfZUmaq1
    Zut4kbq6n9kkpbfNuA3YqZF0xi3cpq90/89exL1xRFnk8jo74j3VJQxajvZuoGyP
    WsiCcNnVNdIPS1go9MG2NZxjQGO/C5REISS7CG1UrlCQRejofoElGFiaJ/w2J2cG
    +lsLTWoVOJBetMMaIY0kuYwx8YviIpou4KM9qN0DAgMBAAGjgYQwgYEwHQYDVR0O
    BBYEFKt8/u9UI/61KFYXCFjmN2YpwmdNMEUGA1UdIwQ+MDyAFKt8/u9UI/61KFYX
    CFjmN2YpwmdNoSGkHzAdMRswGQYDVQQDExJmcmVlcmFkaXVzLXRlbXAtY2GCAQAw
    DAYDVR0TBAUwAwEB/zALBgNVHQ8EBAMCAQYwDQYJKoZIhvcNAQELBQADggEBAAbJ
    vOrPT7JlghjucyPA2whsbDHpqSeukHlfA7KISmfFqWz71kZPn25Bq8POOlGEnvss
    wX+L5QhkeW1SwMTdZONooqkrUmPte2AD8wZqyrJGcwYpMgJtA3k48BnELgcMuZah
    RcxJVdshMzjyPzZPs4w2YBb3H1qMoV7lybGRc9EQRo1AP0dZFFtg0ay1CtPVTfg6
    /Bl/s4YDMduq1tqNaB3qwrG6WC4MTBRRz6Axthb+pgzviRzsTBE73+NZg6Ur2JMR
    J+O01EILfh9KL6r0CJn0mCLoq83wGVhhOanQSydgdAbigwupoFuDeLDFjtKl6knr
    Cdcn0Zk0dqmeKOqVZYk=
    -----END CERTIFICATE-----
  '';
in {
  age.identityPaths = ["/home/sewer/.ssh/id_rsa"];

  age.secrets = {
    nexus-vpn = {
      file = ./secrets/nexus-vpn.env.age;
      mode = "600";
    };

    nexus-vpn-ta = {
      file = ./secrets/nexus-vpn-ta.age;
      mode = "600";
    };
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.age.secrets.nexus-vpn.path];
    profiles.nexus-vpn = {
      connection = {
        id = "nexus-vpn";
        type = "vpn";
        permissions = "user:sewer:";
      };

      ipv4 = {
        method = "auto";
      };

      ipv6 = {
        method = "auto";
      };

      vpn = {
        "service-type" = "org.freedesktop.NetworkManager.openvpn";
        "connection-type" = "password";
        auth = "SHA256";
        cipher = "AES-128-CBC";
        "challenge-response-flags" = "2";
        dev = "tun";
        ca = "${caCert}";
        remote = "$VPN_REMOTE";
        "remote-cert-tls" = "server";
        ta = config.age.secrets.nexus-vpn-ta.path;
        "ta-dir" = "1";
        "password-flags" = "0";
        username = "$VPN_USERNAME";
      };

      "vpn-secrets" = {
        password = "$PASSWORD";
      };
    };
  };
}
