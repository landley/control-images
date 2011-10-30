#!/bin/bash

if [ "$1" != "all" ] && [ ! -x "images/$1/build.sh" ]
then
  echo 'Available images (or "all"):'
  ls images
  exit 1
fi

build_control_image()
{
  (
    IMAGENAME="$1"
    MYDIR=$(readlink -f images/"$1")
    BUILDER="$MYDIR"/build.sh
    [ -e "$BUILDER" ] || BUILDER=common/builder.sh

    source common/include.sh &&
    source $BUILDER &&
    squash_image
  )
}

if [ "$1" != all ]
then
  build_control_image "$1"
else
  for i in $(ls images)
  do
    echo "=== Checking $i"
    [ -e build/$i.hdc ] && echo "build/$i.hdc exists" && continue
    build_control_image "$i" || exit 1
  done
fi
