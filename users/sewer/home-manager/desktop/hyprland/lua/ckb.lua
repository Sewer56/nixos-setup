-- Corsair keyboard (ckb-next) autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("ckb-next -b")
end)
