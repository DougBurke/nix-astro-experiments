{ stdenv, fetchurl }:

# wcstools provides a set of command-line tools and a library (as a .a
# file). Rather than have a single derivation provide both (with flags
# to control which a user wants) I have decided to have separate
# derivations. This does mean that if you were to install both libwcs
# and wcstools then the library from libwcs would not have been used
# to create the binaries in wcstools, but I think that's acceptable.
#
stdenv.mkDerivation rec {

  name = "libwcs-${version}";
  version = "3.9.5";

  src = fetchurl {
      url = "http://tdc-www.harvard.edu/software/wcstools/wcstools-${version}.tar.gz";
      sha256 = "177ywl8b9hvw9hz9acznsarnmz8vfy39k2h2833g0agczmavxydj";
  };

  buildPhase = ''
    cd libwcs
    make
  '';

  # It's not clear what header files are neaded, so use the ones
  # mentioned in
  # http://tdc-www.harvard.edu/software/wcstools/subroutines/libwcs.wcs.html
  # and then hack until things work
  #
  installPhase = ''
    mkdir -p $out/include/ $out/lib/

    cp wcs.h $out/include/
    cp wcslib.h $out/include/
    cp fitshead.h $out/include/
    
    cp libwcs.a $out/lib/
  '';

  # libwcs has a COPYING file which states GNU LESSER GENERAL PUBLIC LICENSE
  # version 2.1 I don't know if it supports later versions so stick
  # with 2.1 only.
  #
  meta = {
    description = "World Coordinate System Subroutines from wcstools";
    homepage = http://tdc-www.harvard.edu/software/wcstools/subroutines/libwcs.wcs.html;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
