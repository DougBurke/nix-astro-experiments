# Can we build CIAO 4.11 tools (with Nix-provided OTS)?
#

{ pkgs, stdenv, which, pkgconfig, bison, flex, python35, gfortran, cfitsio }:

let
  # is this needed?
  python35Env = python35.withPackages(ps: with ps; [ numpy ]);

  # xpa = pkgs.callPackage ./xpa.nix { };
  libwcs = pkgs.callPackage ./libwcs.nix { };

in

stdenv.mkDerivation rec {

  name = "ciao-tools-${version}";
  version = "4.11";

  # Assume already unpacked
  src = "../ciao-${version}/";

  nativeBuildInputs = [ which bison flex pkgconfig gfortran python35 ];

  buildInputs = [ libwcs cfitsio python35Env ];

  # builder = ./builder.sh;
  
  meta = with stdenv.lib; {
    description = "Chandra Interactive Analysis of Observations (CIAO) package for X-ray Astronomy data";
    homepage = "http://cxc.harvard.edu/ciao/"; 
    # maintainers = [ maintainers.cmcdragonkai ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
