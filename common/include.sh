#!/bin/bash

# Grab common shell functions

source common/utility_functions.sh || exit 1
source common/download_functions.sh || exit 1

# Figure out where everything is:

[ -z "$TOP" ] && TOP="$(pwd)"
[ -z "$BUILD" ] && BUILD="$TOP/build"

# what directory is this script in, and what's that directory called?
[ -z "$MYDIR" ] && MYDIR="$(readlink -f "$(dirname "$(which "$0")")")"
[ -z "$IMAGENAME" ] && IMAGENAME="${MYDIR/*\//}"

# Directories for downloaded source tarballs and patches.

[ -z "$PATCHDIR" ] && PATCHDIR="$MYDIR/patches"
[ -z "$SRCDIR" ] && SRCDIR="$TOP/packages/$IMAGENAME"
mkdir -p "$SRCDIR" || dienow

# Put package cache in the control image, so the target system image can
# build from this source.

WORK="$TOP/build/$IMAGENAME" &&
SRCTREE="$WORK" &&
blank_tempdir "$WORK" &&

squash_image()
{
  # Create squashfs image

  if [ ! -z "$(which mksquashfs)" ]
  then
    mksquashfs "$WORK" "$WORK.hdc" -noappend -all-root || dienow
  else
    echo "No mksquashfs in path"
  fi
}
