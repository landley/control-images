# Build Linux From Scratch 6.7 packages under target environment.

# Note: this doesn't rebuild the toolchain packages (libc, binutils,
# gcc, linux-headers), but reuses the toolchain we've got, because:

# 1) Building a new toolchain is a target-dependent can of worms.
# 2) Doing so would lose distcc acceleration.
# 3) Building glibc under uClibc is buggy because glibc expects that a
#    2.6 kernel will have TLS, and uClibc without NPTL doesn't.  (Yes,
#    repeat after me, "autoconf is useless".)

# Download upstream tarball

URL=http://ftp.osuosl.org/pub/lfs/lfs-packages/lfs-packages-6.8.tar \
SHA1=6ea087c36553a13f4da1152014d226806013db15 \
RENAME='s/-sources//' \
download || dienow

URL=ftp://penma.de/code/gettext-stub/gettext-stub-1.tar.gz \
SHA1=ef706667010893c5492173c543d2c5b715abb8a7 \
download || dienow

# Call cleanup before we move SRCDIR

cleanup_oldfiles

# Extract the individual packages from the upstream tarball

SRCDIR="$SRCTREE/lfs-packages"
PATCHDIR="$SRCDIR"

# Fixups for tarball names the Aboriginal extract scripts can't parse into
# package name, version number, and archive type.

mv "$SRCDIR"/expect{,-}5.45.tar.gz &&
mv "$SRCDIR"/sysvinit-2.88{dsf,}.tar.bz2 &&
mv "$SRCDIR"/tcl{8.5.9-src,-src-8.5.9}.tar.gz &&
mv "$SRCDIR"/udev-{166-testfiles,testfiles-166}.tar.bz2 || exit 1

# Remove damaged patches (whitespace damaged, don't apply without "fuzz").

rm "$SRCDIR"/gcc-4.5.2-startfiles_fix-1.patch &&
rm "$SRCDIR"/procps-3.2.8-fix_HZ_errors-1.patch || exit 1
#rm "$SRCDIR"/tar-1.23-overflow_fix-1.patch || exit 1

# Break down upstream tarball

for i in $(cd "$SRCDIR"; ls *.tar.*)
do
  extract_package $(noversion $i)
done

rm -rf "$SRCDIR"
