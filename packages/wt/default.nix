{
  pkgs,
  lib,
  ...
}: let
  pythonEnv = pkgs.python3.withPackages (p: [
    p.click
  ]);
in
  pkgs.writeShellApplication {
    name = "wt";
    runtimeInputs = [
      pkgs.git
    ];
    text = ''
      exec ${pythonEnv}/bin/python ${./wt.py} "$@"
    '';
  }
