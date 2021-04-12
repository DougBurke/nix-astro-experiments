{ stdenv, lib
, fetchFromGitHub
, file, which, zip
, autoconf, libtool
, gfortran, perl
, libX11, libXft, zlib, libxml2, libxslt
, tcl }:

# SAOImageDS9 build. There is support for building on macOS but
# it has not been tested.
#
stdenv.mkDerivation rec {

  name = "ds9-${version}";
  version = "8.3b1";  # what is the best label for a dev build?

  src = fetchFromGitHub {
    owner = "SAOImageDS9";
    repo = "SAOImageDS9";
    rev = "3836320650b9ca8fdeee012334ba100ad6bff4c2";
    sha256 = "0n0hxazi2jamnz01wcvblnjh2ld7qwmgqlmgwnjyn9b3l9ca6v96";
    fetchSubmodules = true;
  };

  # I still don't understand the difference between nativeBuildInputs
  # and buildInputs.
  #
  nativeBuildInputs = [
    file which zip
    autoconf libtool
    gfortran
  ];

  buildInputs = [
    libX11 libXft zlib libxml2 libxslt
    tcl
    perl
  ];

  # With changes in ds9 8.3 we need to do a lot less mangling of the build.
  #
  configureScript = (if stdenv.isDarwin then "macos" else "unix") + "/configure";
  
  # I am sure this was needed, but apparently not now. I have left it commented
  # out in case ot "things".
  #
  ## hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/bin
    for x in ds9 xpaaccess xpaget xpainfo xpamb xpans xpaset ; do
      cp bin/$x $out/bin
    done

    # only copy over the XPA man pages
    mkdir -p $out/man/man1
    cp man/man1/xpa*1 $out/man/man1
    
  '';

  # I assume that something in the stripping messes up all of
  # DS9's internal paths, since it can not find files within its
  # own file system after the standard fixupPhase, so skip for now.
  #
  dontStrip = true;
  
  meta = {
    description = "Interactive data visualization (focusing on Astronomy)";
    longDescription = ''
    SAOImage DS9 is an astronomical imaging and data visualization
    application. DS9 supports FITS images and binary tables, multiple
    frame buffers, region manipulation, and many scale algorithms and
    colormaps. It provides for easy communication with external
    analysis tasks and is highly configurable and extensible via XPA
    and SAMP.

    DS9 is a stand-alone application. It requires no installation or
    support files. All versions and platforms support a consistent set
    of GUI and functional capabilities.

    DS9 supports advanced features such as 2-D, 3-D and RGB frame
    buffers, mosaic images, tiling, blinking, geometric markers,
    colormap manipulation, scaling, arbitrary zoom, cropping,
    rotation, pan, and a variety of coordinate systems.

    The GUI for DS9 is user configurable. GUI elements such as the
    coordinate display, panner, magnifier, horizontal and vertical
    graphs, button bar, and color bar can be configured via menus or
    the command line.

    The XPA command-line tools are currently included, since they allow
    communication between DS9 and external programs. This may change.
    '';

    homepage = http://ds9.si.edu/;
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
