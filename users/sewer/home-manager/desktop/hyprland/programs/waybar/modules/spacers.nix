{
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
    #waybar.bar #custom-spacer3 {
      font-size: 10pt;
      font-weight: bold;
      color: #45475a;
      background: transparent;
    }
  '';
}
