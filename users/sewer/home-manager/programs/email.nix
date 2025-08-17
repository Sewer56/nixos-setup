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

  # Message filter configuration reference:
  # - name: descriptive name for the filter
  # - enabled: true/false (whether filter is active)
  # - type: "17" (standard message filter type: InboxRule + Manual = 1 + 16 = 17)
  # - condition: logical expression (e.g., "AND (from,contains,@github.com)" or "OR (subject,contains,delivery)")
  # - action: "Move to folder", "Mark read", "Mark flagged", "Delete", etc.
  # - actionValue: IMAP URL for multi-account setups: "imap://user%40domain@server/Folder"
  #   Uses URL-encoded secrets (*-encoded.age files) where @ becomes %40
  # - extraConfig: additional filter configuration parameters
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

          # Message filters for automatic organization
          messageFilters = [
            {
              name = "Security";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,security alert) "
                + "OR (subject,contains,verification) "
                + "OR (subject,contains,login) "
                + "OR (subject,contains,2fa) "
                + "OR (subject,contains,two-factor) "
                + "OR (from,contains,security@) "
                + "OR (from,contains,@bitwarden.com) "
                + "OR (from,contains,@accounts.google.com) "
                + "OR (from,contains,verification@)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-googlemail-encoded.age}@imap.gmail.com/Security";
            }
            {
              name = "Discord";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@discord.com) "
                + "OR (from,contains,support@discord.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-googlemail-encoded.age}@imap.gmail.com/Discord";
            }
            {
              name = "Gaming-Marketing";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@humblebundle.com) "
                + "OR (from,contains,@mailer.humblebundle.com) "
                + "OR (from,contains,@indiegala.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-googlemail-encoded.age}@imap.gmail.com/Gaming-Marketing";
            }
            {
              name = "Gaming-Platform";
              enabled = true;
              type = "17";
              condition = "AND (from,contains,@nexusmods.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-googlemail-encoded.age}@imap.gmail.com/Gaming-Platform";
            }
          ];
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

          # Message filters for work email organization
          messageFilters = [
            {
              name = "Security";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,security alert) "
                + "OR (subject,contains,verification) "
                + "OR (subject,contains,login) "
                + "OR (subject,contains,2fa) "
                + "OR (subject,contains,two-factor) "
                + "OR (from,contains,security@) "
                + "OR (from,contains,@bitwarden.com) "
                + "OR (from,contains,@accounts.google.com) "
                + "OR (from,contains,verification@)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Security";
            }
            {
              name = "GitHub";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@github.com) "
                + "OR (from,contains,notifications@github.com) "
                + "OR (from,contains,noreply@github.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/GitHub";
            }
            {
              name = "Financial";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@paypal.com) "
                + "OR (from,contains,security@paypal.co.uk) "
                + "OR (from,contains,@trading212.com) "
                + "OR (from,contains,@info.trading212.com) "
                + "OR (from,contains,@danskebank.co.uk) "
                + "OR (from,contains,@commail.danskebank.co.uk)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Financial";
            }
            {
              name = "Deliveries";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@amazon.com) "
                + "OR (from,contains,@amazon.co.uk) "
                + "OR (subject,contains,Your order) "
                + "OR (subject,contains,delivery) "
                + "OR (subject,contains,shipped)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Deliveries";
            }
            {
              name = "Crypto";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@kraken.com) "
                + "OR (from,contains,@coinbase.com) "
                + "OR (from,contains,@binance.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Crypto";
            }
            {
              name = "Food-Delivery";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@subway.com) "
                + "OR (from,contains,@just-eat.co.uk) "
                + "OR (from,contains,@deliveroo.com) "
                + "OR (from,contains,@ubereats.com) "
                + "OR (from,contains,@dominos.com) "
                + "OR (from,contains,@mcdonalds.com) "
                + "OR (subject,contains,your food) "
                + "OR (subject,contains,order ready)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Food-Delivery";
            }
            {
              name = "Cloud-Storage";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@pcloud.com) "
                + "OR (from,contains,@sync.com) "
                + "OR (from,contains,@dropbox.com) "
                + "OR (from,contains,@onedrive.com) "
                + "OR (subject,contains,storage) "
                + "OR (subject,contains,sync) "
                + "OR (subject,contains,cloud)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Cloud-Storage";
            }
            {
              name = "Gaming-Software";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@cdkeys.com) "
                + "OR (from,contains,@p.cdkeys.com) "
                + "OR (from,contains,@stardock.net) "
                + "OR (from,contains,@Ko-fi.com) "
                + "OR (from,contains,@indiegala.com) "
                + "OR (subject,contains,game key) "
                + "OR (subject,contains,software license)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Gaming-Software";
            }
            {
              name = "AI-Development";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@groq.com) "
                + "OR (from,contains,@windsurf.ai) "
                + "OR (from,contains,@coderabbit.ai) "
                + "OR (from,contains,@gitkraken.com) "
                + "OR (subject,contains,API) "
                + "OR (subject,contains,development)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/AI-Development";
            }
            {
              name = "Professional";
              enabled = true;
              type = "17";
              condition =
                "OR "
                + "(subject,contains,alumni) "
                + "OR (subject,contains,packaging) "
                + "OR (subject,contains,work) "
                + "OR (subject,contains,professional)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Professional";
            }
            {
              name = "Billing";
              enabled = true;
              type = "17";
              condition =
                "OR "
                + "(subject,contains,invoice) "
                + "OR (subject,contains,bill) "
                + "OR (subject,contains,payment) "
                + "OR (subject,contains,receipt)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Billing";
            }
            {
              name = "Communications";
              enabled = true;
              type = "17";
              condition =
                "OR "
                + "(subject,contains,phone) "
                + "OR (subject,contains,mobile) "
                + "OR (subject,contains,telecom)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-atwork-encoded.age}@imap.gmail.com/Communications";
            }
          ];
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

          # Message filters for personal domain email (ordered by priority)
          messageFilters = [
            {
              name = "Security";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,security alert) "
                + "OR (subject,contains,verification) "
                + "OR (subject,contains,login) "
                + "OR (subject,contains,2fa) "
                + "OR (subject,contains,two-factor) "
                + "OR (from,contains,security@) "
                + "OR (from,contains,@bitwarden.com) "
                + "OR (from,contains,@accounts.google.com) "
                + "OR (from,contains,verification@)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Security";
            }
            {
              name = "Travel";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,flight) "
                + "OR (subject,contains,boarding) "
                + "OR (subject,contains,check-in) "
                + "OR (subject,contains,travel) "
                + "OR (subject,contains,booking) "
                + "OR (subject,contains,itinerary) "
                + "OR (subject,contains,train) "
                + "OR (subject,contains,hotel) "
                + "OR (subject,contains,trip) "
                + "OR (subject,contains,airline) "
                + "OR (subject,contains,departure) "
                + "OR (subject,contains,arrival) "
                + "OR (from,contains,@ryanair.com) "
                + "OR (from,contains,@easyjet.com) "
                + "OR (from,contains,@aerlingus.com) "
                + "OR (from,contains,@flights.aerlingus.com) "
                + "OR (from,contains,@fly.aerlingus.com) "
                + "OR (from,contains,@booking.com) "
                + "OR (from,contains,@hotels.com)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Travel";
            }
            {
              name = "Development";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,notify@aur.archlinux.org) "
                + "OR (subject,contains,AUR) "
                + "OR (subject,contains,wine) "
                + "OR (from,contains,api@) "
                + "OR (subject,contains,development) "
                + "OR (subject,contains,opensource) "
                + "OR (subject,contains,github) "
                + "OR (subject,contains,repository)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Development";
            }
            {
              name = "Government";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,.gov.uk) "
                + "OR (from,contains,.gov) "
                + "OR (subject,contains,official) "
                + "OR (subject,contains,tax) "
                + "OR (subject,contains,hmrc) "
                + "OR (subject,contains,dvla) "
                + "OR (subject,contains,passport) "
                + "OR (subject,contains,visa)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Government";
            }
            {
              name = "Health";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,health) "
                + "OR (subject,contains,medical) "
                + "OR (subject,contains,NHS) "
                + "OR (subject,contains,doctor) "
                + "OR (subject,contains,appointment) "
                + "OR (from,contains,@nhs.uk) "
                + "OR (subject,contains,prescription)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Health";
            }
            {
              name = "Deliveries";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,delivery) "
                + "OR (subject,contains,shipped) "
                + "OR (subject,contains,order) "
                + "OR (subject,contains,tracking) "
                + "OR (subject,contains,parcel) "
                + "OR (subject,contains,dispatch)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Deliveries";
            }
            {
              name = "Politics";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,politics) "
                + "OR (subject,contains,news) "
                + "OR (subject,contains,newsletter) "
                + "OR (subject,contains,election) "
                + "OR (subject,contains,political) "
                + "OR (subject,contains,government) "
                + "OR (subject,contains,department) "
                + "OR (subject,contains,petition) "
                + "OR (subject,contains,petitions) "
                + "OR (subject,contains,committee) "
                + "OR (from,contains,petition.parliament.uk)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Politics";
            }
            {
              name = "Professional";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,professional) "
                + "OR (subject,contains,business) "
                + "OR (subject,contains,contract) "
                + "OR (subject,contains,invoice) "
                + "OR (subject,contains,employment) "
                + "OR (subject,contains,job) "
                + "AND NOT (subject,contains,flight) "
                + "AND NOT (subject,contains,travel) "
                + "AND NOT (subject,contains,trip)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-sewer56.dev-encoded.age}@mail.privateemail.com/Professional";
            }
          ];
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

          # Enhanced filters for YouTube account
          messageFilters = [
            {
              name = "Security";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,security alert) "
                + "OR (subject,contains,verification) "
                + "OR (subject,contains,login) "
                + "OR (subject,contains,2fa) "
                + "OR (subject,contains,two-factor) "
                + "OR (from,contains,security@) "
                + "OR (from,contains,@accounts.google.com) "
                + "OR (from,contains,verification@)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-youtube-encoded.age}@imap.gmail.com/Security";
            }
            {
              name = "YouTube-Platform";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@youtube.com) "
                + "OR (from,contains,@google.com) "
                + "OR (subject,contains,youtube) "
                + "OR (subject,contains,creator) "
                + "OR (subject,contains,monetization)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-youtube-encoded.age}@imap.gmail.com/YouTube-Platform";
            }
            {
              name = "Content-Tools";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,video) "
                + "OR (subject,contains,channel) "
                + "OR (subject,contains,analytics) "
                + "OR (subject,contains,copyright) "
                + "OR (subject,contains,content)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-youtube-encoded.age}@imap.gmail.com/Content-Tools";
            }
          ];
        };
      };

      # Gaming platform work account
      nexusmods = {
        address = decryptSecret ../secrets/email-nexusmods.age;
        userName = decryptSecret ../secrets/email-nexusmods.age;
        flavor = "gmail.com";
        realName = "Sewer";

        thunderbird = {
          enable = true;
          profiles = ["default"];

          # Enhanced filters for gaming platform work account
          messageFilters = [
            {
              name = "Security";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,security alert) "
                + "OR (subject,contains,verification) "
                + "OR (subject,contains,login) "
                + "OR (subject,contains,2fa) "
                + "OR (subject,contains,two-factor) "
                + "OR (from,contains,security@) "
                + "OR (from,contains,@accounts.google.com) "
                + "OR (from,contains,verification@)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-nexusmods-encoded.age}@imap.gmail.com/Security";
            }
            {
              name = "Platform-Internal";
              enabled = true;
              type = "17";
              condition =
                "OR (from,contains,@nexusmods.com) "
                + "OR (subject,contains,nexus) "
                + "OR (subject,contains,internal) "
                + "OR (subject,contains,platform)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-nexusmods-encoded.age}@imap.gmail.com/Platform-Internal";
            }
            {
              name = "Work-Professional";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,work) "
                + "OR (subject,contains,professional) "
                + "OR (subject,contains,meeting) "
                + "OR (subject,contains,project) "
                + "OR (subject,contains,task)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-nexusmods-encoded.age}@imap.gmail.com/Work-Professional";
            }
            {
              name = "Gaming-Industry";
              enabled = true;
              type = "17";
              condition =
                "OR (subject,contains,gaming) "
                + "OR (subject,contains,modding) "
                + "OR (subject,contains,community) "
                + "OR (subject,contains,developer) "
                + "OR (subject,contains,industry)";
              action = "Move to folder";
              actionValue = "imap://${decryptSecret ../secrets/email-nexusmods-encoded.age}@imap.gmail.com/Gaming-Industry";
            }
          ];
        };
      };
    };
  };
}
