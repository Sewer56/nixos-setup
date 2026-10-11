# NVIDIA driver setup for the desktop and laptop.
# Laptop PRIME setup is in hosts/laptop/default.nix.
# Many tweaks come from https://gitlab.com/fazzi/nixohess/-/blob/main/modules/hardware/nvidia.nix
# Reference: https://wiki.nixos.org/wiki/Nvidia
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Values allowed in hostOptions.hardware.nvidia.driverVersion.
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

  # Terminal GPU monitor.
  environment.systemPackages = with pkgs; [
    nvitop
  ];

  # Load the driver early from the initrd.
  # Otherwise nvidia-drm can load 28s+ late, miss the monitors on warm boot,
  # and DisplayPort falls back to 60Hz instead of 240Hz.
  # Off on the laptop: its EFI partition is too small.
  boot.initrd.kernelModules = lib.mkIf config.hostOptions.hardware.nvidia.earlyLoading [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  # NixOS should set these already, but they've gone missing before.
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  environment.sessionVariables = {
    # Allow G-Sync/VRR. Without these, Hyprland reports `vrr: false`.
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # Queue at most one frame, for lower latency.
    __GL_MaxFramesAllowed = "1";

    # Shader cache: on, 12 GiB max, out of ~/.nv.
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SIZE = toString (12 * 1024 * 1024 * 1024);
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";

    # CUDA cache out of ~/.nv too.
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";

    # Don't force high clocks whenever CUDA runs.
    CUDA_DISABLE_PERF_BOOST = "1";

    # Fix GPU acceleration in bwrap sandboxes (osu!lazer, wrapped AppImages).
    __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS = "/run/current-system/etc/egl/egl_external_platform.d";

    # Proton: expose NVIDIA D3D12 shader extensions and use descriptor heaps.
    DXVK_NVAPI_D3D12_NV_SHADER_EXTN = "1";
    VKD3D_CONFIG = "descriptor_heap";
  };

  # Driver profiles applied to every process (`feature = "true"`).
  # Safe alongside NVIDIA's own rules: matching rules merge,
  # and ours use the same values NVIDIA does.

  # Lower VRAM use. NVIDIA only does this for compositors,
  # and its Hyprland rule misses NixOS's ".Hyprland-wrapped".
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

  # Don't hold CUDA apps at the slower P2 state. NVIDIA only does this for OBS and Discord.
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
    # Needed by Wayland compositors.
    modesetting.enable = true;

    # NVIDIA's open kernel module (not nouveau). Needs a Turing (RTX 20 / GTX 16) or newer GPU.
    open = true;

    nvidiaSettings = true;

    # Save all VRAM on suspend, to avoid glitches after wake. Experimental.
    powerManagement.enable = true;

    # Set per host with hostOptions.hardware.nvidia.driverVersion.
    package = driverPackages.${selectedDriver};

    # Not copying fazzi's nvidia-drm.vblank=1: driver 595 doesn't have it, so the module won't load.
    moduleParams = {
      nvidia = {
        # Faster CPU writes to GPU memory.
        NVreg_UsePageAttributeTable = 1;

        # Resizable BAR. Needs "Above 4G decoding" and "Resizable BAR" on in the BIOS.
        NVreg_EnableResizableBar = 1;

        # Lower display latency.
        NVreg_RegistryDwords = "RmEnableAggressiveVblank=1";
      };
    };
  };
}
