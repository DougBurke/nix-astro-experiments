let
  pkgs = import <nixpkgs> { };
in
  pkgs.callPackage ./wcstools.nix {}
