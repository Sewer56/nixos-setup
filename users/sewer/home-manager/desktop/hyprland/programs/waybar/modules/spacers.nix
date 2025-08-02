semantic: {
  config = {
    "custom/spacer1" = {
      format = " \\\\ ";
      tooltip = false;
    };

    "custom/spacer2" = {
      format = " ";
      tooltip = false;
    };

    "custom/spacer3" = {
      format = " // ";
      tooltip = false;
    };
  };

  style = ''
    #waybar.bar #custom-spacer1,
    #waybar.bar #custom-spacer2,
    #waybar.bar #custom-spacer3,
    #waybar.bottom-bar #custom-spacer1,
    #waybar.bottom-bar #custom-spacer2,
    #waybar.bottom-bar #custom-spacer3 {
      font-weight: bold;
      color: ${semantic.border};
      background: transparent;
    }
  '';
}
