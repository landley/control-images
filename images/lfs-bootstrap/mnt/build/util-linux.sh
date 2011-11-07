#!/bin/sh

sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
  -i $(grep -rl '/etc/adjtime' .) &&
# uClibc hasn't got argp.h, and it's the wrong header to include anyway.
sed -e 's/<argp[.]h>/<errno.h>/' -i configure &&
# They never tested --disable-nls and use gettext() directly without masking it.
sed -e '/define _(/{n;/define N_(/a \# define gettext(Text) (Text)' -e '}' -i include/nls.h &&
mkdir -p /var/lib/hwclock &&
./configure --enable-arch --enable-partx --enable-write --disable-nls &&
make -j $CPUS &&
make install
