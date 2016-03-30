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
  # Work around bug in hush
  [ -z "$i" ] && continue

  X=$(($X+1))
  if [ -z "$FORCE" ] && grep -q "$i" "$MANIFEST"
  then
    echo "$i already installed"
    continue
  fi
  if [ ! -z "$RECORD" ]
  then
    [ "${RECORD:0:1}" != "," ] && RECORD=",$RECORD"
    if [ "$RECORD" == ,all ] || [ "$RECORD" != "${RECORD/,$i/}" ]
    then
      echo recording commands for $i
      export RECORD_COMMANDS=record-commands
    else
      RECORD_COMMANDS=
    fi
  fi
  X_OF_Y="($X of $PACKAGECOUNT)" /mnt/build-one-package.sh "$i" || exit 1
  
  sed -i -e "/$i/d" "$MANIFEST" &&
  echo "$i" >> "$MANIFEST" || exit 1
done
