# NVIDIA GPU configuration
# This module configures NVIDIA graphics cards with Intel Prime offloading
# Reference: https://wiki.nixos.org/wiki/Nvidia
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Map driver version option to actual package
  driverPackages = {
    stable = config.boot.kernelPackages.nvidiaPackages.stable;
    beta = config.boot.kernelPackages.nvidiaPackages.beta;
    production = config.boot.kernelPackages.nvidiaPackages.production;
    vulkan_beta = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    latest = config.boot.kernelPackages.nvidiaPackages.latest;
    legacy_470 = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    legacy_390 = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  };
  selectedDriver = config.hostOptions.hardware.nvidia.driverVersion;
in {
  imports = [
    ./common.nix
  ];

  # NVIDIA-specific packages
  environment.systemPackages = with pkgs; [
    nvitop
  ];

  # Early loading of NVIDIA kernel modules in initrd.
  # Without this, nvidia-drm registers late (28s+ after boot on some systems)
  # and fails to properly enumerate displays on warm boot:
  #   "Failed to get dynamic displays during device registration"
  #   "Cannot find any crtc or sizes"
  # This causes DP link training to fall back to 60Hz instead of 240Hz.
  # Gated by hostOptions: only desktop enables this (laptop ESP too small).
  boot.initrd.kernelModules = lib.mkIf config.hostOptions.hardware.nvidia.earlyLoading [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  # Explicit kernel params: the NixOS nvidia module conditionally adds these
  # but only when services.xserver.enable=true for kernelModules. Force them
  # unconditionally since they've been observed missing from cmdline.
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  # NVIDIA VRR must be explicitly allowed via env vars on the open kernel module.
  # Without these, the driver won't expose VRR capability to Wayland compositors,
  # resulting in vrr: false even when misc:vrr is set in Hyprland.
  # Gaming/cache tweaks borrowed from fazzi/nixohess:
  # https://gitlab.com/fazzi/nixohess/-/blob/main/modules/hardware/nvidia.nix
  environment.sessionVariables = {
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # Cap frames in flight in the OpenGL driver queue -> lower latency
    __GL_MaxFramesAllowed = "1";

    # Shader disk cache: enabled, 12GiB cap, kept under XDG cache instead of ~/.nv
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = toString (12 * 1024 * 1024 * 1024);
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";

    # Keep the CUDA compute cache out of ~/.nv too
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    # Stop forcing max clocks whenever anything touches CUDA (battery/heat)
    CUDA_DISABLE_PERF_BOOST = "1";

    # Fix NVIDIA EGL hw accel inside bwrap sandboxes (wrapped appimages, osu!lazer)
    __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/current-system/etc/egl/egl_external_platform.d";

    # Proton gaming: report D3D12 NV shader extensions to VKD3D-Proton and use
    # descriptor heaps (both queue-related perf wins on NV hardware)
    DXVK_NVAPI_D3D12_NV_SHADER_EXTN = "1";
    VKD3D_CONFIG = "descriptor_heap";
  };

  # NVIDIA application profiles (borrowed from fazzi/nixohess, see URL above).
  # feature "true" = catch-all rule, applies to every process.
  #
  # Safe with vendor rules: per README "Rule Precedence", settings from ALL
  # matching rules merge, and on key conflicts the earlier file wins. Our
  # catch-all only sets GLVidHeapReuseRatio / CudaNoStablePerfLimit, with the
  # same values the vendor database uses, so NVIDIA's own per-application
  # rules keep working unchanged.
  #
  # 50: "No VidMem Reuse" (GLVidHeapReuseRatio=0): vendor applies this only to
  # compositors (incl. "Hyprland", though that rule misses NixOS's
  # ".Hyprland-wrapped" procname); globalizing it trades VRAM headroom for
  # slightly more realloc work in every GL process.
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-vram-alloc-fixes.json".text = builtins.toJSON {
    rules = [
      {
        pattern = {
          feature = "true";
          matches = "";
        };
        profile = "No VidMem Reuse";
      }
    ];
  };

  # 51: "CudaNoStablePerfLimit": stop locking CUDA processes to the stable p2
  # perf state (vendor ships this only for obs/Discord). Note this pulls
  # against CUDA_DISABLE_PERF_BOOST=1 above; different mechanisms (perf lock
  # vs boost), so they coexist.
  environment.etc."nvidia/nvidia-application-profiles-rc.d/51-dont-nerf-cuda-perf.json".text = builtins.toJSON {
    rules = [
      {
        pattern = {
          feature = "true";
          matches = "";
        };
        profile = "CudaNoStablePerfLimit";
      }
    ];
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Driver version is configurable per-host via hostOptions.hardware.nvidia.driverVersion
    package = driverPackages.${selectedDriver};

    # Kernel module parameters borrowed from fazzi/nixohess:
    # https://gitlab.com/fazzi/nixohess/-/blob/main/modules/hardware/nvidia.nix
    # NOTE: ReBAR only takes effect with "Above 4G decoding" + "Resizable BAR"
    # enabled in BIOS; the param is harmless without it.
    # NOTE: fazzi also sets nvidia-drm.vblank=1, but driver 595 exposes no such
    # module param (only modeset/fbdev) and an unknown param aborts module load.
    moduleParams = {
      nvidia = {
        # Faster PCIe write path; safe and long-recommended
        NVreg_UsePageAttributeTable = 1;
        # Resizable BAR
        NVreg_EnableResizableBar = 1;
        # Low-latency vblank handling. Registry dwords are passed through the
        # generic string param.
        NVreg_RegistryDwords = "RmEnableAggressiveVblank=1";
      };
      # Don't force memory clocks to P0 while VRR is active (flicker/power)
      nvidia-modeset.disable_vrr_memclk_switch = 1;
    };
  };
}
