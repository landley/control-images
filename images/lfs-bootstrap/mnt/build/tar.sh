#!/bin/sh

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --bindir=/bin \
  --libexecdir=/usr/sbin &&
make -j $CPUS || exit 1

if [ ! -z "$CHECK" ]
then
  make check || exit 1
fi

make install
