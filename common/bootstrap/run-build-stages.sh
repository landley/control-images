#!/bin/sh

# Run each of the individual package build files, in order.

[ -z "$MANIFEST" ] && MANIFEST=/usr/src/packages
touch "$MANIFEST"
  
[ -z "$FILTER" ] || FILTER="/$FILTER/d"
PACKAGES="$(sed -r -e "$FILTER" -e "s@#.*@@" /mnt/package-list)"
PACKAGECOUNT=$(echo "$PACKAGES" | wc -w)
X=0
for i in $PACKAGES
do
  X=$(($X+1))
  if [ -z "$FORCE" ] && grep -q "$i" "$MANIFEST"
  then
    echo "$i already installed"
    continue
  fi
  X_OF_Y="($X of $PACKAGECOUNT)" /mnt/build-one-package.sh "$i" || exit 1
  
  sed -i -e "/$i/d" "$MANIFEST" &&
  echo "$i" >> "$MANIFEST" || exit 1
done
