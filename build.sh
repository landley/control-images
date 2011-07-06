#/bin/bash

if [ "$1" != "all" ] && [ ! -x "images/$1/build.sh" ]
then
  echo 'Available images (or "all"):'
  ls images
  exit 1
fi

if [ "$1" != all ]
then
  images/"$1"/build.sh
else
  for i in $(ls images)
  do
    images/"$i"/build.sh || exit 1
  done
fi
