let
  pkgs = import <nixpkgs> { };
in
  pkgs.callPackage ./ciao-tools.nix {}
