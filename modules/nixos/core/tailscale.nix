{...}: {
  # Enable Tailscale service
  services.tailscale.enable = true;

  # Trust packets routed over Tailscale
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
