{...}: {
  # Configure tmpfs for /tmp directory
  boot.tmp.cleanOnBoot = true;

  # Don't use tmpfs, because huge builds can fail due to size limits
  #boot.tmp = {
  #  useTmpfs = true;
  #  tmpfsSize = "50%";
  #};
}
