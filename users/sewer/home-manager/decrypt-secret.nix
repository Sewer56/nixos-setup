{
  pkgs,
  inputs,
  ...
}: {
  decryptSecret = secretFile: let
    filename = builtins.baseNameOf secretFile;
    relativePath = "secrets/${filename}";
  in
    builtins.exec [
      "${pkgs.bash}/bin/bash"
      "-c"
      ''
        set -euo pipefail
        f=$(mktemp)
        trap "rm $f" EXIT
        cd /etc/nixos/users/sewer/home-manager
        ${inputs.agenix.packages.${pkgs.system}.default}/bin/agenix -d "${relativePath}" --identity "/home/sewer/.ssh/id_rsa" > "$f"
        ${pkgs.nix}/bin/nix-instantiate --eval -E "builtins.readFile $f"
      ''
    ];
}
