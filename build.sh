#/bin/bash

if [ -z "$1" ] || [ ! -x "images/$1/build.sh" ]
then
  echo "Available images:"
  ls images
fi

images/"$1"/build.sh
