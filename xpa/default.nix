let
  pkgs = import <nixpkgs> { };
in
  pkgs.callPackage ./xpa.nix {}
