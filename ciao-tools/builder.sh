source "$stdenv"/setup

# in case we already have a copy
rm -rf "$(basename "$src")"

cp --recursive "$src" ./
chmod --recursive u=rwx ./"$(basename "$src")"

cd ./"$(basename "$src")"

# Hack in the version file: there is a --with-ver flag
# in configure which we can use to over-ride this, but it looks
# like the file is checked for in either case.
#
echo "CIAO 4.11 Wednesday, December  5, 2018" > VERSION

# Hack Python vesion support in src/libdev/grplib.
#
# Note that the test in configure is going to break
# once the Python micro version gets above .9 (if this
# can ever happen).
#
sed -e 's/3.5.5/3.5.9/g' --in-place src/libdev/grplib/configure

# Apply other patches
#   - not patching src/lib/datamodel/nutils/
#       [nan | cop | fiopathlist | iofs | mixarray | keylib].c
#     since not "simple" and may indicate an actual logical error
#     (or deal with NaN's)
#
# The aim is to clean up the build somewhat, but my idea of having a
# warning-free build has quickly evaporated, like a dream in the morning.
#
patch -p2 < ../patch.region_repr
patch -p2 < ../patch.rbits
patch -p2 < ../patch.format
patch -p2 < ../patch.bytes
patch -p2 < ../patch.posix  # this patch doesn't help
patch -p2 < ../patch.read
patch -p2 < ../patch.cop
patch -p2 < ../patch.copenlib

patch -p2 < ../patch.dmibuffer
patch -p2 < ../patch.dmidd
patch -p2 < ../patch.dmicoord
patch -p2 < ../patch.dmiddlib
patch -p2 < ../patch.dmdsspriv
patch -p2 < ../patch.dmsubspace
patch -p2 < ../patch.dmreglib
patch -p2 < ../patch.dmparselib
patch -p2 < ../patch.dmclause
patch -p2 < ../patch.dmicoordlib

patch -p2 < ../patch.ftdataset
patch -p2 < ../patch.ftscan
patch -p2 < ../patch.ftkeylist
patch -p2 < ../patch.ftkernel
patch -p2 < ../patch.ftwcs
patch -p2 < ../patch.ftdtype
patch -p2 < ../patch.ftrows
patch -p2 < ../patch.ftfilter
patch -p2 < ../patch.ftblocklib
patch -p2 < ../patch.fttablib
patch -p2 < ../patch.ftvecmap
patch -p2 < ../patch.ftsubspace
patch -p2 < ../patch.ftcoord


# This is a complete hack and I don't know why it is needed. Have I
# missed a step or is this a symptom of the build assuming the OTS is
# present? As far as I can tell the files exist in diretories
# that are referenced via -I<path> (at least in some cases).
#
cp src/lib/region/src/cxcregion.h src/lib/region/regtest/bin/
cp src/lib/region/src/region_priv.h src/lib/region/regtest/bin/

cp src/lib/datamodel/include/*.h src/lib/datamodel/nutils/
cp src/lib/datamodel/include/*.h src/lib/datamodel/dmu/
cp src/lib/datamodel/include/*.h src/lib/datamodel/dmi/

# How do I copy in the libwcs.h/.a files?

# Where should these be set?
#  for testing I don't want to bother with optimisation
#
# export CFLAGS="-03"
# export CXXFLAGS="-03"

# do not need to fix the pc files as not using the CIAO-provided ones!
# bash src/config/fixpc.sh `pwd`

# Note: no opt for now, but need to be explicit about pkgconfig
#
# ./configure --with-fits --with-ascii --with-opt=-O3

# CIAO has specific ideas about the location of its OTS; can we get this
# directory name in a better manner?
#
pkgdir=`/usr/bin/which pkg-config`
pkgdir=`dirname $pkgdir`/..

./configure --with-fits --with-ascii --with-pkgconfig="$pkgdir" \
  --prefix="$out" --with-ver='CIAO-nix 4.11'

# For historical reasons, you have to use 'make install' and not 'make'
#
make install
