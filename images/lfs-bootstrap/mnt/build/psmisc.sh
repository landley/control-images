#!/bin/sh

# Another bugfix that you'd think would be a patch, but no...

sed -i 's@#include<sys\/usr.h>@#include <bits\/types.h>\&@' configure &&
sed -i '/#error /d' src/peekfd.c &&

./configure --prefix=/usr --disable-nls &&
make -j $CPUS &&
make install
