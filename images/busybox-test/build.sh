#!/bin/bash

# Run the busybox test suite.

source common/include.sh || exit 1

# Don't download busybox, it's got to already be there in standard sources.

EXTRACT_ALL=1

URL=http://www.busybox.net/downloads/busybox-1.18.4.tar.bz2 \
SHA1=d285855e5770b0fb7caf477dd41ce0863657b975 \
maybe_fork "download || dienow"

cat > "$WORK"/init << 'EOF' || dienow
#!/bin/bash

echo === $HOST Run busybox test suite

cp -sfR /mnt/busybox busybox && cd busybox &&
make defconfig &&
ln -s /bin/busybox busybox &&
cd testsuite &&
./runtest &&
cd .. &&
rm -rf busybox || exit 1

sync

EOF
chmod +x "$WORK"/init || dienow

squash_image
