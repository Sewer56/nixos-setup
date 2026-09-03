{...}: {
  # Power off the PC once every opencode instance has gone idle.
  # Idle is detected by silence in the shared log all instances append to.
  home.file.".local/bin/opencode-auto-poweroff" = {
    text = ''
      #!/usr/bin/env bash
      # Power off after all opencode instances are idle.
      # Idle = the shared log has not been written for OPENCODE_AUTO_POWEROFF_TIMEOUT seconds.
      # Any write cancels the countdown; a cancel file aborts at every stage.
      # Set OPENCODE_AUTO_POWEROFF_CMD to a no-op when testing, e.g. "echo dry-run".
      set -u

      LOG="''${OPENCODE_LOG:-$HOME/.local/share/opencode/log/opencode.log}"
      # Seconds of log silence before starting the shutdown countdown.
      TIMEOUT="''${OPENCODE_AUTO_POWEROFF_TIMEOUT:-1800}"
      # Seconds between countdown start and poweroff, time to cancel.
      GRACE="''${OPENCODE_AUTO_POWEROFF_GRACE:-120}"
      # Seconds between log mtime checks.
      POLL="''${OPENCODE_AUTO_POWEROFF_POLL:-60}"
      # Command that powers off; override it so tests never shut the machine down.
      POWEROFF_CMD="''${OPENCODE_AUTO_POWEROFF_CMD:-systemctl poweroff}"
      CANCEL="''${XDG_RUNTIME_DIR:-/tmp}/opencode-auto-poweroff.cancel"
      LOCK="''${XDG_RUNTIME_DIR:-/tmp}/opencode-auto-poweroff.lock"

      # Only one instance may run; a second would delete the cancel file mid-countdown.
      exec 9>"$LOCK"
      flock -n 9 || exit 0

      if [ ! -f "$LOG" ]; then
        echo "opencode log not found: $LOG" >&2
        exit 1
      fi

      # Drop a cancel file left by a previous run so this run starts armed.
      rm -f "$CANCEL"

      while :; do
        [ -e "$CANCEL" ] && exit 0
        # After this line: quiet is seconds since last log write, or the log vanished.
        if ! quiet=$(( $(date +%s) - $(stat -c %Y "$LOG") )) 2>/dev/null; then
          echo "opencode log vanished: $LOG" >&2
          exit 1
        fi
        [ "$quiet" -ge "$TIMEOUT" ] && break
        sleep "$POLL"
      done

      command -v wall >/dev/null && wall "opencode idle $((TIMEOUT / 60)) min, powering off in $((GRACE / 60)) min. touch $CANCEL to abort."
      command -v notify-send >/dev/null && notify-send "opencode idle" "Powering off in $((GRACE / 60)) min. touch $CANCEL to abort."

      sleep "$GRACE"
      [ -e "$CANCEL" ] && exit 0
      $POWEROFF_CMD
    '';
    executable = true;
  };
}
