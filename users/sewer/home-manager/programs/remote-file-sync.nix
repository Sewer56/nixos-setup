{config, ...}: {
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
    };
  };
}
