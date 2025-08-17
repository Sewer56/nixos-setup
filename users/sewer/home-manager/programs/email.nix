{
  pkgs,
  inputs,
  ...
}: let
  decryptSecretModule = import ../decrypt-secret.nix {inherit pkgs inputs;};
  inherit (decryptSecretModule) decryptSecret;
in {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

  # Enable email account management with evaluation-time decrypted email addresses
  # Using custom evaluation-time secrets system that decrypts agenix secrets during build
  accounts.email = {
    accounts = {
      # Primary Gmail account
      sewer56lol = {
        primary = true;
        address = decryptSecret ../secrets/email-googlemail.age;
        userName = decryptSecret ../secrets/email-googlemail.age;
        realName = "Sewer";
        flavor = "gmail.com";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # Work/Business Gmail account
      seweratwork = {
        address = decryptSecret ../secrets/email-atwork.age;
        userName = decryptSecret ../secrets/email-atwork.age;
        flavor = "gmail.com";
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # Personal domain account
      "sewer56.dev" = {
        address = decryptSecret ../secrets/email-sewer56.dev.age;
        userName = decryptSecret ../secrets/email-sewer56.dev.age;
        realName = "Sewer";

        # Namecheap private email server settings
        imap = {
          host = "mail.privateemail.com";
          port = 993;
          tls.enable = true;
        };

        smtp = {
          host = "mail.privateemail.com";
          port = 465;
          tls.enable = true;
        };

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # YouTube account
      youtube = {
        address = decryptSecret ../secrets/email-youtube.age;
        userName = decryptSecret ../secrets/email-youtube.age;
        flavor = "gmail.com";
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # Nexus Mods work account
      nexusmods = {
        address = decryptSecret ../secrets/email-nexusmods.age;
        userName = decryptSecret ../secrets/email-nexusmods.age;
        flavor = "gmail.com";
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };
    };
  };
}
