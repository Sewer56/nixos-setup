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
      googlemail = {
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
      work = {
        address = decryptSecret ../secrets/email-work.age;
        userName = decryptSecret ../secrets/email-work.age;
        flavor = "gmail.com";
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # Personal domain account
      personal = {
        address = decryptSecret ../secrets/email-personal.age;
        userName = decryptSecret ../secrets/email-personal.age;
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];
        };
      };

      # Secondary Gmail account
      secondary = {
        address = decryptSecret ../secrets/email-secondary.age;
        userName = decryptSecret ../secrets/email-secondary.age;
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
