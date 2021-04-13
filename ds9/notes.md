# How do I get the rev and sha256 for the source download

% nix-shell -p 'nix-prefetch-github'
...
% which nix-prefetch-github
/nix/store/w9pjkssf21s9dpb962dnzxjcd1vjfx13-python3.8-nix-prefetch-github-4.0.3/bin/nix-prefetch-github
% nix-prefetch-github SAOImageDS9 SAOImageDS9 --nix
let
  pkgs = import <nixpkgs> {};
in
  pkgs.fetchFromGitHub {
    owner = "SAOImageDS9";
    repo = "SAOImageDS9";
    rev = "3836320650b9ca8fdeee012334ba100ad6bff4c2";
    sha256 = "0n0hxazi2jamnz01wcvblnjh2ld7qwmgqlmgwnjyn9b3l9ca6v96";
    fetchSubmodules = true;
  }

# Debugging the build

From this old, but useful, reddit post:
https://www.reddit.com/r/NixOS/comments/6kdpu7/setting_up_a_development_environment/

% nix-shell
nix% unpackPhase
unpacking source archive /nix/store/bbx1ih1i5zbb7nfbqa5f0z8skffzbvwj-source
source root is source
nix% ls source
BUILD.txt  awthemes   fitsy         openssl     tclconfig  tclsignal  tkagif   tkimg     tktable    unix    xpa
LICENSE    compilers  funtools      scidthemes  tclfitsy   tclxml     tkblt    tkmacosx  tkwin      util
README.md  ds9        macos         taccle      tcliis     tclzipfs   tkcon    tkmpeg    tls        vector
ast        fickle     make.include  tcl8.6      tcllib     tk8.6      tkhtml1  tksao     ttkthemes  win
nix% buildPhase
no Makefile, doing nothing

nix% echo $configureScript
unix/configure
nix% configurePhase
fixing libtool script ./source/ast/build-aux/ltmain.sh
fixing libtool script ./source/tkimg/compat/libtiff/config/ltmain.sh
fixing libtool script ./source/tkimg/compat/libpng/ltmain.sh
fixing libtool script ./source/tkimg/compat/libjpeg/ltmain.sh
configure flags: --prefix=/nix/store/40y4i3k4fppbnn3k8bwgxx3bm93va89y-ds9-8.3b1
bash: unix/configure: No such file or directory

Aha, need to be in the source directory:

nix% cd source
nix% configurePhase
fixing libtool script ./ast/build-aux/ltmain.sh
fixing libtool script ./tkimg/compat/libtiff/config/ltmain.sh
fixing libtool script ./tkimg/compat/libpng/ltmain.sh
fixing libtool script ./tkimg/compat/libjpeg/ltmain.sh
configure flags: --prefix=/nix/store/40y4i3k4fppbnn3k8bwgxx3bm93va89y-ds9-8.3b1
checking TEA configuration... ok (TEA 3.13)
configure: configuring saods9 8.3
checking system version... Linux-5.4.0-67-generic
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking how to run the C preprocessor... gcc -E
checking whether make sets $(MAKE)... yes
checking for ranlib... ranlib
checking for grep that handles long lines and -e... /nix/store/wmiyjdsaydyv024al5ddqd3liljrfvk7-gnugrep-3.6/bin/grep
checking for egrep... /nix/store/wmiyjdsaydyv024al5ddqd3liljrfvk7-gnugrep-3.6/bin/grep -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking if the compiler understands -pipe... yes
checking whether byte ordering is bigendian... no
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking how to build libraries... shared
checking for ranlib... (cached) ranlib
checking if 64bit support is requested... no
checking if 64bit Sparc VIS support is requested... no
checking if compiler supports visibility "hidden"... yes
checking if rpath support is requested... yes
checking system version... (cached) Linux-5.4.0-67-generic
checking for ar... ar
checking for cast to union support... yes
checking for required early compiler flags...  _LARGEFILE64_SOURCE
checking for 64-bit integer type... using long
checking for build with symbols... no
checking system version... (cached) Linux-5.4.0-67-generic
configure: creating ./config.status
config.status: creating Makefile

As a check

nix% unix/configure --help
`configure' configures saods9 8.3 to adapt to many kinds of systems.

Usage: unix/configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/saods9]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]

Optional Features:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --enable-shared         build and link with shared libraries (default: on)
  --enable-stubs          build and link with stub libraries. Always true for
                          shared builds (default: on)
  --enable-64bit          enable 64bit support (default: off)
  --enable-64bit-vis      enable 64bit Sparc VIS support (default: off)
  --disable-rpath         disable rpath support (default: on)
  --enable-wince          enable Win/CE support (where applicable)
  --enable-symbols        build with debugging symbols (default: off)

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-celib=DIR        use Windows/CE support library from DIR
  --with-arch             build name

Some influential environment variables:
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor
  CXX         C++ compiler command
  CXXFLAGS    C++ compiler flags

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to the package provider.
