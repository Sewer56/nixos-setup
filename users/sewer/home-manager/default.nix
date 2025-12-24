{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./packages.nix
    ./desktop/hyprland.nix
    ./desktop/desktop-entries.nix
    ./shell.nix
    ./programs/terminal.nix
    ./programs/starship.nix
    ./programs/monitor.nix
    ./programs/fetch.nix
    ./programs/email.nix
    ./programs/video-player.nix
    ./programs/vesktop.nix
    ./programs/udiskie.nix
    ./programs/file-manager.nix
    ./programs/mangohud.nix
    ./programs/rust.nix
    ./programs/direnv.nix
    ./programs/remote-file-sync.nix
    ./programs/music-streaming.nix
    ./programs/claude-code/default.nix
    ./programs/opencode/default.nix
    ./programs/corsair/ckb-next.nix
    ./programs/password-manager.nix
    ./programs/stretchly/default.nix
    ./programs/uv.nix
    ./themes/default.nix
    ./theme.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sewer";
  home.homeDirectory = "/home/sewer";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Ensure systemd user services start automatically during Home Manager activation
  # This is required for services that depend on agenix secrets
  systemd.user.startServices = "sd-switch";

  # User-specific packages
  home.packages = with pkgs; [
    # Development tools
    vscode
    gitkraken

    # Note taking
    obsidian

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sewer56";
        email = "sewer@sewer56.dev";
      };
    };
    lfs.enable = true;
    package = pkgs.gitFull;
  };
  programs.gh.enable = true;
  programs.gh.gitCredentialHelper.enable = true;

  # Agenix configuration for secrets management
  age.secrets = {
    # Example secret configurations (uncomment as needed):
    wallhaven-api-key = {
      file = ./secrets/wallhaven-api-key.age;
      path = "${config.home.homeDirectory}/.secrets/wallhaven-api-key";
      mode = "600";
    };

    # RClone Mount
    rclone-token = {
      file = ./secrets/rclone-token.age;
    };

    # Proton Drive credentials for rclone
    proton-drive-username = {
      file = ./secrets/proton-drive-username.age;
    };
    proton-drive-password = {
      file = ./secrets/proton-drive-password.age;
    };

    # GitHub Personal Access Token for Claude Code MCP servers
    github-token = {
      file = ./secrets/github-token.age;
      path = "${config.home.homeDirectory}/.secrets/github-token";
      mode = "600";
    };

    # Nix access tokens for GitHub rate limiting
    nix-access-tokens = {
      file = ./secrets/nix-access-tokens.age;
      path = "${config.home.homeDirectory}/.secrets/nix-access-tokens";
      mode = "600";
    };

    # Nexus API key
    nexus-api-key = {
      file = ./secrets/nexus-api-key.age;
      path = "${config.home.homeDirectory}/.secrets/nexus-api-key";
      mode = "600";
      symlink = false; # Needs to be read before agenix kicks in
    };

    # Reloaded-II wiki
    reloaded-wiki-search-github-api-key = {
      file = ./secrets/reloaded-wiki-search-github-api-key.age;
      path = "${config.home.homeDirectory}/.secrets/reloaded-wiki-search-github-api-key";
      mode = "600";
      symlink = false; # Needs to be read before agenix kicks in
    };
  };

  # Configure nix access tokens to avoid GitHub rate limiting
  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-tokens.path}
  '';

  # Environment variables
  home.sessionVariables = {
    NEXUS_API_KEY = "$(cat ${config.age.secrets.nexus-api-key.path})";
    RELOADED_WIKI_GITHUB_TOKEN_FILE = "${config.age.secrets.reloaded-wiki-search-github-api-key.path}";
    RELOADEDIIMODS = "/home/sewer/Desktop/Reloaded-II/Mods";
  };
}
