{pkgs, ...}: let
  # Hyprland session that launches the compositor binary directly via uwsm,
  # bypassing `start-hyprland`.
  #
  # start-hyprland has crash-recovery: on any non-clean exit it relaunches
  # Hyprland with `--safe-mode`, which resets to default binds/keyboard/layout.
  # Under uwsm teardown (shutdown/lockups) Hyprland frequently gets killed
  # uncleanly, so the safe-mode prompt keeps appearing. Launching Hyprland
  # directly skips start-hyprland entirely; uwsm still manages the session.
  hyprlandSession = pkgs.writeTextFile {
    name = "hyprland-direct";
    text = ''
      [Desktop Entry]
      Name=Hyprland (direct)
      Comment=Hyprland compositor via uwsm, no start-hyprland safe-mode
      Exec=/run/current-system/sw/bin/uwsm start -e -D Hyprland -F -- /run/current-system/sw/bin/Hyprland
      DesktopNames=Hyprland
      Type=Application
    '';
    destination = "/share/wayland-sessions/hyprland-direct.desktop";
    derivationArgs = {
      passthru.providedSessions = ["hyprland-direct"];
    };
  };
in {
  # Login Screen / SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };

  # Expose the direct-launch session to the display manager.
  services.displayManager.sessionPackages = [hyprlandSession];

  # Machine-specific SDDM autologin
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "hyprland-direct.desktop";
      User = "sewer";
    };
  };
}
