{...}: {
  # Configure tmpfs for /tmp directory
  boot.tmp.cleanOnBoot = true;

  # Don't use tmpfs, because huge builds can fail due to size limits
  #boot.tmp = {
  #  useTmpfs = true;
  #  tmpfsSize = "50%";
  #};

  # Allow EXE files to be automatically executed through Wine
  boot.binfmt.emulatedSystems = ["x86_64-windows" "i686-windows"];
}
