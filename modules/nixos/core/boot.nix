{...}: {
  # Configure tmpfs for /tmp directory
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}
