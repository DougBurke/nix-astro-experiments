{ stdenv, fetchurl }:

# wcstools provides a set of command-line tools and a library (as a .a
# file). Rather than have a single derivation provide both (with flags
# to control which a user wants) I have decided to have separate
# derivations. This does mean that if you were to install both libwcs
# and wcstools then the library from libwcs would not have been used
# to create the binaries in wcstools, but I think that's acceptable.
#
stdenv.mkDerivation rec {

  name = "wcstools-${version}";
  version = "3.9.5";

  src = fetchurl {
      url = "http://tdc-www.harvard.edu/software/wcstools/wcstools-${version}.tar.gz";
      sha256 = "177ywl8b9hvw9hz9acznsarnmz8vfy39k2h2833g0agczmavxydj";
  };

  # Should this use Makefile.osx on macOS systems?
  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/bin/ $out/man/man1

    cp bin/* $out/bin
    cp man/man1/* $out/man/man1
  '';

  # wcstools has a COPYING file which states GNU GENERAL PUBLIC LICENSE
  # version 2. I don't know if it supports later versions so stick
  # with 2 only.
  #
  meta = {
    description = "World Coordinate System tools from wcstools";
    homepage = http://tdc-www.harvard.edu/software/wcstools/wcsprogs.html;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
