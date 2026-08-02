{pkgs, ...}: {
  # Install nwg-displays for monitor configuration
  home.packages = with pkgs; [
    nwg-displays
  ];

  # Create empty monitors.lua if it doesn't exist
  # This allows for non-declarative monitor configuration
  # (required by lua/config.lua; file is user-editable with hl.monitor calls)
  home.activation.createMonitorsLua = ''
    MONITORS_LUA="$HOME/.config/hypr/monitors.lua"
    if [ ! -f "$MONITORS_LUA" ]; then
      run echo "Creating empty monitors.lua at $MONITORS_LUA"
      run mkdir -p "$(dirname "$MONITORS_LUA")"
      run printf -- "-- Managed manually. Use hl.monitor({ output = ..., mode = ..., position = ..., scale = ... }) calls.\n" > "$MONITORS_LUA"
    fi
  '';
}
