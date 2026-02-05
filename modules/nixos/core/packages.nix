{pkgs, ...}: let
  dotnet-combined = (with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_10_0
      sdk_9_0
      sdk_8_0
    ]).overrideAttrs (finalAttrs: previousAttrs: {
    # This is needed to install workload in $HOME
    # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2
    postBuild =
      (previousAttrs.postBuild or "")
      + ''
        for i in $out/sdk/*
        do
          i=$(basename $i)
          mkdir -p $out/metadata/workloads/''${i/-*}
          touch $out/metadata/workloads/''${i/-*}/userlocal
        done
      '';
  });
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nix development tools
    nixd # language server
    alejandra # formatter

    # NFS utilities
    nfs-utils

    # .NET development
    dotnet-combined

    # system profiling
    perf

    # flatpak & discover
    kdePackages.discover
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
  };
}
