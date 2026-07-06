{...}: {
  programs.mpv = {
    enable = true;
    config = {
      osd-status-msg = "\${playback-time/full} / \${duration} (\${percent-pos}%)\\nframe: \${estimated-frame-number} / \${estimated-frame-count}";
      vd-lavc-skiploopfilter = "all"; # always skip deblock on corrupt streams
      vd-lavc-show-all = "yes";
    };
  };
}
