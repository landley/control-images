#!/bin/bash

# Download all the source tarballs we haven't got up-to-date copies of.

# The tarballs are downloaded into the "packages" directory, which is
# created as needed.

EXTRACT_ALL=1

echo "=== Download source code."

# Note: set SHA1= blank to skip checksum validation.

URL=http://downloads.sf.net/sourceforge/strace/strace-4.9.tar.xz \
SHA1=5e6c78f0dc75e64814e5f8ef49c66823b7f00ae9 \
maybe_fork download || dienow

URL=http://zlib.net/zlib-1.2.8.tar.gz \
SHA1=a4d316c404ff54ca545ea71a27af7dbc29817088 \
maybe_fork "download || dienow"

URL=http://matt.ucc.asn.au/dropbear/releases/dropbear-2014.66.tar.bz2 \
SHA1=793f5f1bb465b3c55e795d607932e8b21c130e95 \
maybe_fork download || dienow

echo === Got all source.

cleanup_oldfiles

cat > "$WORK"/init << 'EOF' || dienow
#!/bin/bash

upload_result()
{
  ftpput $FTP_SERVER -P $FTP_PORT "$1-$HOST" "$1"
}

echo Started second stage init

echo === Native build static zlib

cp -sfR /mnt/zlib zlib &&
cd zlib &&
# 
rm -f Makefile zconf.h &&
./configure &&
make -j $CPUS &&
cd .. || exit 1

echo === $HOST Native build static dropbear

cp -sfR /mnt/dropbear dropbear &&
cd dropbear &&
CFLAGS="-I ../zlib -Os" LDFLAGS="--static -L ../zlib" ./configure &&
sed -i 's@/usr/bin/dbclient@ssh@' options.h &&
make -j $CPUS PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1 SCPPROGRESS=1 &&
strip dropbearmulti &&
upload_result dropbearmulti &&
cd .. &&
rm -rf dropbear || exit 1

echo === $HOST native build static strace

cp -sfR /mnt/strace strace &&
cd strace &&
CFLAGS="--static -Os" ./configure &&
make -j $CPUS &&
strip strace &&
upload_result strace &&
cd .. &&
rm -rf strace || dienow

#echo === $HOST native build rsync

sync

EOF

chmod +x "$WORK"/init || dienow
