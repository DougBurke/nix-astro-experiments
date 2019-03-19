{ stdenv, fetchurl, file }:

stdenv.mkDerivation rec {

  name = "xpa-${version}";
  version = "2.1.18";

  src = fetchurl {
      url = "https://github.com/ericmandel/xpa/archive/v${version}.tar.gz";
      sha256 = "0yvqmbq4ml4g6rbqz26b3na4jn1sphvs0kyywaybl11jj5dhbjd8";
  };

  nativeBuildInputs = [ file ];
  
  # could support --with-gtk= and --with-tcl= but leave that for later
  #
  configureFlags = [ "--enable-shared=link"
                     "--enable-threaded-xpans"
		     "--with-threads" ];

  meta = {
    description = "seamless communication between many kinds of Unix programs, including X programs and Tcl/Tk programs.";
    homepage = https://github.com/ericmandel/xpa;
    license = stdenv.lib.licenses.mit;
    # I am only testing on linux
    platforms = stdenv.lib.platforms.linux;
  };
}
