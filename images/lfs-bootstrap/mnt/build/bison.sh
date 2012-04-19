#!/bin/sh

sed -i 's/#ifndef __GLIBC__/#if !defined __GLIBC__ || defined __UCLIBC__/' \
  lib/spawn.in.h || exit 1

./configure --prefix=/usr &&
echo '#define YYENABLE_NLS 1' >> lib/config.h &&
make -j $CPUS || exit 1

if [ ! -z "$CHECK" ]
then
  make check || exit 1
fi

make install
