{
  config,
  pkgs,
  ...
}: let
  # Reusable function to extract secrets from rclone config
  extractSecret = remote: key: ''
    $(
    tmp=$(mktemp)
    ${pkgs.rclone}/bin/rclone config dump --config "/home/sewer/.config/rclone/.rclone.conf.orig" \
      | ${pkgs.jq}/bin/jq -r '.["${remote}"]."${key}" // empty' > "$tmp"
    echo "$tmp"
    )'';
in {
  # https://home-manager-options.extranix.com/?query=rclone&release=master
  programs.rclone = {
    enable = true;

    remotes = {
      "Cloud" = {
        config = {
          type = "pcloud";
          hostname = "api.pcloud.com";
        };

        secrets = {
          token = config.age.secrets.rclone-token.path;
        };

        mounts = {
          "" = {
            enable = true;
            mountPoint = "/home/sewer/Cloud";
            options = {
              vfs-cache-mode = "full";
              vfs-cache-min-free-space = "10Gi";
              vfs-refresh = true;
            };
          };
        };
      };

      # "Cloud-private" = {
      #   config = {
      #     type = "protondrive";
      #     enable_caching = false;
      #   };

      #   secrets = {
      #     username = config.age.secrets.proton-drive-username.path;
      #     password = config.age.secrets.proton-drive-password.path;
      #     "2fa" = extractSecret "Cloud-private" "2fa";
      #     client_uid = extractSecret "Cloud-private" "client_uid";
      #     client_access_token = extractSecret "Cloud-private" "client_access_token";
      #     client_refresh_token = extractSecret "Cloud-private" "client_refresh_token";
      #     client_salted_key_pass = extractSecret "Cloud-private" "client_salted_key_pass";
      #   };

      #   mounts = {
      #     "" = {
      #       enable = true;
      #       mountPoint = "/home/sewer/Cloud-private";
      #       options = {
      #         vfs-cache-mode = "full";
      #         vfs-cache-min-free-space = "10Gi";
      #         vfs-refresh = true;
      #       };
      #     };
      #   };
      # };
    };
  };
}
