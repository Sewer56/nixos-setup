{
  pkgs,
  inputs,
  ...
}: let
  # Helper function to decrypt agenix secrets using builtins.exec
  decryptSecret = secretFile: let
    # Get just the filename from the path and prepend "secrets/"
    filename = builtins.baseNameOf secretFile;
    relativePath = "secrets/${filename}";
  in
    # Use builtins.exec with inline script (enabled by allow-unsafe-native-code-during-evaluation)
    builtins.exec [
      "${pkgs.bash}/bin/bash"
      "-c"
      ''
        set -euo pipefail
        f=$(mktemp)
        trap "rm $f" EXIT
        cd /etc/nixos/users/sewer/home-manager
        ${inputs.agenix.packages.${pkgs.system}.default}/bin/agenix -d "${relativePath}" --identity  "/home/sewer/.ssh/id_rsa" > "$f"
        ${pkgs.nix}/bin/nix-instantiate --eval -E "builtins.readFile $f"
      ''
    ];
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
