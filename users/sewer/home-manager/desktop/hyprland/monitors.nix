{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nwg-displays
  ];

  # config.lua requires this file. Create it once, then leave local edits alone.
  home.activation.createMonitorsLua = lib.hm.dag.entryAfter ["writeBoundary"] ''
    MONITORS_LUA="$HOME/.config/hypr/monitors.lua"
    if [ ! -f "$MONITORS_LUA" ]; then
      run echo "Creating empty monitors.lua at $MONITORS_LUA"
      run mkdir -p "$(dirname "$MONITORS_LUA")"
      run ${pkgs.runtimeShell} -c 'printf "%s\n" "-- Add local monitor settings here using hl.monitor({ ... })." > "$1"' -- "$MONITORS_LUA"
    fi
  '';
}
