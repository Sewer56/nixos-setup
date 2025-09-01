{pkgs, ...}: {
  imports = [
    ./hyprland/default.nix
  ];

  # Enable Wayland support for Chrome/Chromium-based applications
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Hyprland Window Manager (User Configuration)
  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = null; # Use the default portal package
    plugins = with pkgs.hyprlandPlugins; [
      hypr-dynamic-cursors
      (pkgs.callPackage ({
        lib,
        fetchFromGitHub,
        hyprlandPlugins,
      }:
        hyprlandPlugins.mkHyprlandPlugin pkgs.hyprland {
          pluginName = "hyprWorkspaceLayouts";
          version = "0-unstable-2025-05-10";

          src = fetchFromGitHub {
            owner = "zakk4223";
            repo = "hyprWorkspaceLayouts";
            rev = "d74fa07f4484e7934a26c26cdbe168533451935d";
            hash = "sha256-1dxRcryNRh0zPiuO5EusPY0Qazh6Ogca41C+/gvs15g=";
          };

          nativeBuildInputs = [pkgs.gnumake];

          buildPhase = ''
            runHook preBuild
            make all
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out/lib
            mv workspaceLayoutPlugin.so $out/lib/libhyprWorkspaceLayouts.so
            runHook postInstall
          '';

          meta = {
            homepage = "https://github.com/zakk4223/hyprWorkspaceLayouts";
            description = "Workspace-specific window layouts for Hyprland";
            license = lib.licenses.bsd3;
            platforms = lib.platforms.linux;
            maintainers = [];
          };
        }) {})
    ];
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    xwayland.enable = true;
  };

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland.settings = {
    debug.full_cm_proto = true;
    # unscale XWayland
    xwayland.force_zero_scaling = true;
  };
}
